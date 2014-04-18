
all: doall

doall:
	cd scripts && Rscript update_topdeps.R devel 
	cd scripts && Rscript update_topdeps.R 3.0.3 
	cd scripts && Rscript update_topdeps.R 3.0.2 
	cd scripts && Rscript update_topdeps.R 3.0.1 
	cd scripts && Rscript update_topdeps.R 3.0.0 
	cd scripts && Rscript update_topdeps.R 2.15.3

	cd scripts && Rscript update_alpha.R devel 
	cd scripts && Rscript update_alpha.R 3.0.3 
	cd scripts && Rscript update_alpha.R 3.0.2 
	cd scripts && Rscript update_alpha.R 3.0.1 
	cd scripts && Rscript update_alpha.R 3.0.0 
	cd scripts && Rscript update_alpha.R 2.15.3

	cd scripts && Rscript update_recent.R

.PHONY: all doall
