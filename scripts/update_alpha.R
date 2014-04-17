
## Update the alphabetical pages for a given R version
## R version must be given as a parameter.

HEADER <- "---\nTitle: R-%(version)\nDescription: CRAN packages for R %(version)\ntype: ralpha\n---\n\n# %(initial)\n\n"

source("common.R")

versions <- get_versions()

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1 || ! (args[1] %in% versions)) {
  stop("Version not given or invalid version")
}

version <- args[1]

pkgs <- get_pkgs_for_version(version)
initial <- substr(tolower(names(pkgs)), 1, 1)
alpha <- unique(initial)

odir <- paste0("../_content/r/r", gsub("\\.", "", version))
dir.create(odir)

for (let in alpha) {
  mypkgs <- pkgs[initial == let]

  head <- gsub("%(version)", version, HEADER, fixed=TRUE)
  head <- gsub("%(initial)", toupper(let), head, fixed=TRUE)

  ofile <- paste0(odir, "/", let, ".md")
  cat(head, file=ofile)
  cat(file=ofile, sep="\n\n", append=TRUE,
      paste0("[**", names(mypkgs), "**](",
             github_url, "/", names(mypkgs), " \"view on github\")",
             " — ", "[", mypkgs, "](", github_url, "/",
             names(mypkgs), "/tree/R-", version,
             " \"view version on github\")")
      )

}
