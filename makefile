all: analysis data-preparation

data-preparation:
	make -C src/data-preparation

analysis: data-preparation
	make -C src/analysis
	
clean:
    R -e "unlink('temp', recursive = TRUE)"
    R -e "unlink('data', recursive = TRUE)"