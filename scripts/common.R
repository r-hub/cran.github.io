

library(jsonlite)
library(httr)

url <- "http://rpkg.igraph.org"
github_url <- "https://github.com/cran"

get_versions <- function() {
  vv <- content(GET(paste0(url, "/-/releases")), as="text")
  js <- fromJSON(vv)
  js$version
}

get_pkgs_for_version <- function(version) {
  vv <- content(GET(paste0(url, "/-/release/", version)), as="text")
  js <- fromJSON(vv)
  unlist(js)
}
