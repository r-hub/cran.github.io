
// Utility

function linkify(text) {
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    return text.replace(exp,"<a href='$1'>$1</a>"); 
}

// Function to extract query parameters

function getQueryParams(qs) {
    qs = qs.split("+").join(" ");
    var params = {}, tokens,
    re = /[?&]?([^=]+)=([^&]*)/g;
    while (tokens = re.exec(qs)) {
        params[decodeURIComponent(tokens[1])] =
	    decodeURIComponent(tokens[2]);
    }
    return params;
}
var rawquery = document.location.search
var query = getQueryParams(rawquery);
var mypage=query.page || '1'
document.getElementById("cran_input").value=query.q

// Functions to add results in HTML

function format_package(pkg) {
    var time=moment(pkg.date).fromNow()
    var author=pkg.Maintainer.replace(/ ?<.*>/, '')
    var url=pkg.URL ? ('<div class="packageurl">' + linkify(pkg.URL) +
		       '</div>') : ''
    var html='<div class="package">' +
	'<div class="packagetitle">' + 
	'<a href="https://github.com/cran/' + pkg.Package + '">' + 
	pkg.Package + ' &mdash; ' + pkg.Version + '</a>' + '</div>' + 
	'<div class="packageauthor"> by ' + author +
	', ' + time + '</div>' + '<div class="packagedesc">' + 
	'<p class="alphatitle">' + pkg.Title + '</p>' +
	'<p class="description">' + linkify(pkg.Description) + '</p>' + 
	'</div>' + url +
	'</div>'
    return html
}

function add_results_html(pkg, div) {
    var html = format_package(pkg);
    div.innerHTML += html;
}

function add_results(hits, no_hits) {
    var ndiv=document.getElementById("search_no_results")    
    var div=document.getElementById("search_results")
    var pag=document.getElementById("search_pagination")
    var pag_text=""
    var nop=Math.min(Math.ceil(no_hits / 10), 10)

    if (no_hits == 0) {
	ndiv.innerHTML += "<p>Your search &ndash; <strong>" + query.q + 
	    "</strong> &ndash; did not match any packages"
    } else if (no_hits == 1) {
	ndiv.innerHTML += "<p>Found " + no_hits + " package</p>"
    } else if (mypage == 1) {
	ndiv.innerHTML += "<p>Found " + no_hits + " packages</p>"
    } else {
	ndiv.innerHTML += "<p>Page " + mypage + " of " + no_hits + 
	    " packages</p>"
    }

    for (var i in hits) {
	add_results_html(hits[i]._source, div)
    }

    if (no_hits > 10) { 
	if (mypage != '1') {
	    pag_text += '<span><a href="?q=' + encodeURIComponent(query.q) + 
		'&page=' + (mypage-1) + '">&lt</a></span>'
	}
	for (var i=1; i <= nop; i++) {
	    var paglink='<a href="?q=' + encodeURIComponent(query.q) +
		'&page=' + i + '">' + i + "</a>"
	    if (i == mypage) {
		paglink = '<strong>' + paglink + '</strong>' 
		pag_text += '<span class="current_page">' +
		    paglink + '</span>'
	    } else {
		pag_text += '<span>' + paglink + '</span>'
	    }
	}
	if (mypage != nop) {
	    pag_text += '<span><a href="?q=' + encodeURIComponent(query.q) + 
		'&page=' + (+mypage+1) + '">&gt</a></span>'	
	}
	pag.innerHTML = pag_text;
    }
}

// ElasticSearch client

var client = new elasticsearch.Client({
    host: 'rpkg.igraph.org:9200',
});

// Do the search

client.search({
    index: myindex,
    type: 'package',
    from: (mypage - 1) * 10,
    size: 10,
    "body": {
	"query": {
	    "function_score": {
		"query": { "multi_match": {
		    fields: ["Package^10", "Title^5", "Description^2",
			     "Author^3", "Maintainer^4", "_all" ],
		    query: query.q } },
		"functions": [
		    {
			"script_score": {
			    "script": "_score * doc['revdeps'].value"
			}
		    }
		]
	    }
	}
    }
}).then(function (resp) {
    var hits = resp.hits.hits;
    var no_hist = resp.hits.total;
    add_results(hits, no_hist);
}, function (err) {
    console.trace(err.message);
});
