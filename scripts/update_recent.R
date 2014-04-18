
## Most recently updated

source("common.R")
library(lubridate)

placeholder <- c("<!-- recent-begin -->",
                 "<!-- recent-end -->")

recent <- get_recent(10)
raw_dd <- sapply(recent, function(x) x$package$`Date/Publication`)
dd <- with_tz(ymd_hms(raw_dd, tz="CET"), "UTC")
long_dd <- format(dd, format="%Y-%m-%d %H:%M:%S %Z")
short_dd <- format(dd, format="%m/%d %H:%M")

datestamp <- paste0('<span data-since="', long_dd, '" class="vagueTime">',
                    short_dd, '</span>')

name <- sapply(recent, "[[", "name")

version <- "devel"
myfile <- paste0("../_content/r/r", gsub("\\.", "", version), ".md")

recent_str <- paste0("  - ", datestamp, " ", "[", name, "]",
                  "(", github_url, "/", name, ")",
                  collapse="\n")

lines <- readLines(myfile)
start <- which(lines == placeholder[1])
end <- which(lines == placeholder[2])
if (length(start) != 1 || length(end) != 1) {
  stop("Invalid placeholder(s) in", myfile)
}
cat(lines[1:start], sep="\n", file=myfile)
cat(recent_str, file=myfile, "\n\n", append=TRUE)
cat(lines[end:length(lines)], sep="\n", file=myfile, append=TRUE)
