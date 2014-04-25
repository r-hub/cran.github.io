
source("common.R")

versions <- get_versions()

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1 ||
    (! (args[1] %in% versions) && args[1] != "devel")) {
  stop("Version not given or invalid version")
}

version <- args[1]

substrr <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

weight <- paste0(c("-1", substrr(paste0("0", strsplit(version, "\\.")[[1]]),
                                 2)), collapse="")

file <- paste0("../_input/r/r", gsub("\\.", "", version), ".md")

cnt <- paste0("---
Title: R-", version, "
Description: CRAN packages for R ", version, "
Categories:
 - r
Weight: ", weight, "
---

## Most depended upon

<!-- top-depended-upon-begin -->
<!-- top-depended-upon-end -->
")

cat(cnt, file=file)
