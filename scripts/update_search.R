
## Search pages

source("common.R")

template <- '---
Title: $(title)
Description: ""
type: search
vaguetime: true
index: cran-$(version)
---
'

versions <- get_versions()

for (version in c("devel", versions)) {
  odir <- paste0("../_content/r/r", gsub("\\.", "", version))
  ofile <- paste0(odir, "/search.md")
  dir.create(odir, recursive=TRUE)

  title <- paste0("R-", version)
  temp <- gsub("$(title)", title, template, fixed=TRUE)
  temp <- gsub("$(version)", version, temp, fixed=TRUE)
  
  cat(temp, file=ofile)
}
