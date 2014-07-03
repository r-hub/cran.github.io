

library(jsonlite)
library(httr)

url <- "http://r-pkg.org"
github_url <- "https://github.com/cran"

get_versions <- function() {
  vv <- content(GET(paste0(url, "/-/releases")), as="text")
  js <- fromJSON(vv)
  js$version
}

get_pkgs_for_version <- function(version) {
  vv <- content(GET(paste0(url, "/-/releasedesc/", version)), as="text")
  js <- fromJSON(vv, simplifyDataFrame=FALSE)
}

get_pkgs_for_devel <- function() {
  vv <- content(GET(paste0(url, "/-/desc/")), as="text")
  js <- fromJSON(vv, simplifyDataFrame=FALSE)
}

get_topdeps <- function(version) {
  vv <- content(GET(paste0(url, "/-/topdeps/", version)), as="text")
  js <- unlist(fromJSON(vv, simplifyDataFrame=FALSE))
}

get_recent <- function(how_many=10) {
  vv <- content(GET(paste0(url, "/-/pkgreleases?descending=true&limit=",
                           how_many)), as="text")
  js <- fromJSON(vv, simplifyDataFrame=FALSE)
}

