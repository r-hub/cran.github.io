/**
 * This module formats precise time differences as a vague/fuzzy
 * time, e.g. '3 weeks ago', 'just now' or 'in 2 hours'.
 */

 /*globals define, module */

(function (globals) {
    'use strict';

    var times = {
        year: 31557600000, // 1000 ms * 60 s * 60 m * 24 h * 365.25 d
        month: 2629800000, // 31557600000 ms / 12 m
        week: 604800000, // 1000 ms * 60 s * 60 m * 24 h * 7 d
        day: 86400000, // 1000 ms * 60 s * 60 m * 24 h
        hour: 3600000, // 1000 ms * 60 s * 60 m
        minute: 60000 // 1000 ms * 60 s
    },

    languages = {
        en: {
            year:   ['y', 'y'],
            month:  ['m', 'm'],
            week:   ['w', 'w'],
            day:    ['d', 'd'],
            hour:   ['h', 'h'],
            minute: ['m', 'm'],

            past: function (vagueTime, unit) {
                return vagueTime + ' ' + unit;
            },

            future: function (vagueTime, unit) {
                return 'in ' + vagueTime + ' ' + unit;
            },

            defaults: {
                past: 'just now',
                future: 'soon'
            }
        }
    },

    functions = {
        get: getVagueTime
    };

    exportFunctions();

    /**
     * Public function `get`.
     *
     * Returns a vague time, such as '3 weeks ago', 'just now' or 'in 2 hours'.
     *
     * @option [from] {Date}      The origin time. Defaults to `Date.now()`.
     * @option [to] {Date}        The target time. Defaults to `Date.now()`.
     * @option [units] {string}   If `from` or `to` are timestamps rather than date
     *                            instances, this indicates the units that they are
     *                            measured in. Can be either `ms` for milliseconds
     *                            or `s` for seconds. Defaults to `ms`.
     * @option [lang] {string}    The output language. Defaults to `en`.
     * @option [remaining] {bool} If set, the function returns { timeString:
     *                            [vague time], remaining: [interval in milliseconds]}
     *                            The "remaining" time interval is the time left
     *                            until the vague time changes. Use this to keep
     *                            a vague time continuously updated.
     */
    function getVagueTime (options) {
        var units = normaliseUnits(options.units),
            now = Date.now(),
            from = normaliseTime(options.from, units, now),
            to = normaliseTime(options.to, units, now),
            difference = from - to,
            type,
            estimated;

        if (difference > 0) {
            type = 'past';
        } else {
            type = 'future';
            difference = -difference;
        }

        estimated = estimate(difference, type, options.lang);
        if (options.remaining) return estimated;
        else return estimated.timeString;
    }

    function normaliseUnits (units) {
        if (typeof units === 'undefined') {
            return 'ms';
        }

        if (units === 's' || units === 'ms') {
            return units;
        }

        throw new Error('Invalid units');
    }

    function normaliseTime(time, units, defaultTime) {
        if (typeof time === 'undefined') {
            return defaultTime;
        }

        if (typeof time === 'string') {
            time = parseInt(time, 10);
        }

        if (isNotDate(time) && isNotTimestamp(time)) {
            throw new Error('Invalid time');
        }

        if (typeof time === 'number' && units === 's') {
            time *= 1000;
        }

        return time;
    }

    function isNotDate (date) {
        return Object.prototype.toString.call(date) !== "[object Date]" || isNaN(date.getTime());
    }

    function isNotTimestamp (timestamp) {
        return typeof timestamp !== 'number' || isNaN(timestamp);
    }

    function estimate (difference, type, language) {
        var time, vagueTime, remaining, lang = languages[language] || languages.en;

        for (time in times) {
            if (times.hasOwnProperty(time) && difference >= times[time]) {
                vagueTime = Math.floor(difference / times[time]);
                remaining = times[time] - (difference % times[time]);
                return {
                    timeString: lang[type](vagueTime, lang[time][(vagueTime > 1)+0]),
                    remaining: remaining
                };
            }
        }

        var leastInterval = times.minute;
        return {
            timeString: lang.defaults[type],
            remaining: leastInterval - (difference % leastInterval)
        };
    }

    function exportFunctions () {
        if (typeof define === 'function' && define.amd) {
            define(function () {
                return functions;
            });
        } else if (typeof module !== 'undefined' && module !== null) {
            module.exports = functions;
        } else {
            globals.vagueTime = functions;
        }
    }
}(this));

