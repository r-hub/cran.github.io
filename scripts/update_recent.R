
## Most recently updated

source("common.R")
library(lubridate)

placeholder <- c("<!-- recent-begin -->",
                 "<!-- recent-end -->")

recent <- get_recent(10)
raw_dd <- sapply(recent, function(x) x$package$`Date/Publication`)
dd <- with_tz(ymd_hms(raw_dd, tz="CET"), "UTC")
long_dd <- format(dd, "%a %b %d %Y %H:%M:%S %Z")
short_dd <- format(dd, format="%m/%d %H:%M")

datestamp <- paste0('<span data-since="', long_dd, '" class="vagueTime">',
                    short_dd, '</span>')

name <- sapply(recent, "[[", "name")

version <- "devel"
outfile <- paste0("../_content/r/r", gsub("\\.", "", version), ".md")

if (file.exists(outfile)) {
  infile <- outfile
} else {
  infile <- paste0("../_input/r/r", gsub("\\.", "", version), ".md")
}

recent_str <- paste0("  - ", datestamp, " ", "[", name, "]",
                  "(", github_url, "/", name, ")",
                  collapse="\n")

if (!file.exists("../_content/r")) {
  dir.create("../_content/r")
}

lines <- readLines(infile)
start <- which(lines == placeholder[1])
end <- which(lines == placeholder[2])
if (length(start) != 1 || length(end) != 1) {
  stop("Invalid placeholder(s) in", infile)
}
cat(lines[1:start], sep="\n", file=outfile)
cat(recent_str, file=outfile, "\n\n", append=TRUE)
cat(lines[end:length(lines)], sep="\n", file=outfile, append=TRUE)
