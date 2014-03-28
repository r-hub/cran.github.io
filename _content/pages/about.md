---
Title: About these pages
Description: What this is, and why we are doing it?
---

## What is this?

This is an experiment. It is *not* a production-ready environment, and
it may not be maintained for long.

This is a mirror of all [R](http://www.r-project.org) packages from
the [CRAN repository](http://cran.r-project.org/web/packages/). Each
CRAN package lives in its own github repository, e.g. package _Rcpp_ is at
[`https://github.com/cran/Rcpp`](https://github.com/cran/Rcpp). All
versions of all packages are included, and each version is a separate
git commit, tagged with the version number. We tried to keep the
original dates and authors/maintainers as well.

These repositories are *not* maintained by CRAN maintainers.

## What is the point?

CRAN is a great repository, but it lacks some features that are
important for us. As said above, this is an experiment to see if these
features can be supported. In particular:

 - Easy access to the source code of all packages, online, without
   downloading them. You can search the source code of individual
   packages as well.
 - Show differences between package versions, with ease.
 - Fork and maintain patched versions of packages, again, with ease.
 - Get notified for new package versions.
 - The ability to install packages from *snapshots* of CRAN. Each R
   version corresponds to a snapshot, that contains the CRAN packages
   that were current at the time of the R release. This gives users a
   stable environment, that is easy (well, easier) to reproduce.

## Future goals

 - Easy installation of CRAN snapshots. We are creating an R package
   to install packages and their dependepcies (and their dependencies,
   etc.), all from the same CRAN snapshot.
 - Binary packages.
 - Better search in packages, in particular search in the
   documentation as well.
 - Create a web page for each package, with its documentation.

## What are you working on now?

Take a look at our
[issue tracker](https://github.com/metacran/tools/issues).

## Contact us

You can leave a comment, suggestion, error report, encouragement,
opinion at our [issue tracker](https://github.com/metacran/tools/issues).

If you don't want to sign up to github, then you can also send
me an email at <csardi.gabor@gmail.com>. I really prefer the github
issue tracker, though.


## Contribute

Want to contribute? You can!

- Found an error? Really sorry about it. Please report it in the
  [issue tracker](https://github.com/metacran/tools/issues) and we'll
  try to fix it.
- Have an idea to improve these services? Please open an issue in our
  [issue tracker](https://github.com/metacran/tools/issues) about it,
  and we'll discuss it.
- You want to contribute to our server rental bills? Or you can offer
  reliable (!) server space and/or services? Please contact me at
  <csardi.gabor@gmail.com>.
