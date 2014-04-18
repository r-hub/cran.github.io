
## Most depended upon updates

source("common.R")

placeholder <- c("<!-- top-depended-upon-begin -->",
                 "<!-- top-depended-upon-end -->")

versions <- get_versions()

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1 ||
    (! (args[1] %in% versions) && args[1] != "devel")) {
  stop("Version not given or invalid version")
}

version <- args[1]

top <- get_topdeps(version)[1:10]
top_str <- paste0("  - ", top, " ", "[", names(top), "]",
                  "(", github_url, "/", names(top), ")",
                  collapse="\n")

if (!file.exists("../_content/r")) {
  dir.create("../_content/r")
}

infile <- paste0("../_input/r/r", gsub("\\.", "", version), ".md")
outfile <- paste0("../_content/r/r", gsub("\\.", "", version), ".md")

lines <- readLines(infile)
start <- which(lines == placeholder[1])
end <- which(lines == placeholder[2])
if (length(start) != 1 || length(end) != 1) {
  stop("Invalid placeholder(s) in", infile)
}
cat(lines[1:start], sep="\n", file=outfile)
cat(top_str, file=outfile, "\n\n", append=TRUE)
cat(lines[end:length(lines)], sep="\n", file=outfile, append=TRUE)
