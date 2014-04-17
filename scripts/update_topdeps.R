
## Most depended upon updates
## TODO: per release

source("common.R")

top <- get_topdeps()[1:10]
top_str <- paste0("  - ", top, " ", "[", names(top), "]",
                  "(", github_url, "/", names(top), ")",
                  collapse="\n")

placeholder <- c("<!-- top-depended-upon-begin -->",
                 "<!-- top-depended-upon-end -->")
addto <- "r/rdevel.md"

for (f in addto) {
  myfile <- paste0("../_content/", f)
  lines <- readLines(myfile)
  start <- which(lines == placeholder[1])
  end <- which(lines == placeholder[2])
  if (length(start) != 1 || length(end) != 1) {
    stop("Invalid placeholder(s) in", f)
  }
  cat(lines[1:start], sep="\n", file=myfile)
  cat(top_str, file=myfile, "\n\n", append=TRUE)
  cat(lines[end:length(lines)], sep="\n", file=myfile, append=TRUE)
}
