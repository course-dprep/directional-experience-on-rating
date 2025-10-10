all: reporting/report.pdf

gen/temp/imdb_movies.csv:
	make -C src/data-preparation

gen/output/visual_directeffect.png: gen/temp/imdb_movies.csv
	make -C src/analysis

reporting/data_exploration.pdf: gen/temp/imdb_movies.csv
	Rscript -e "rmarkdown::render('reporting/data_exploration.Rmd', output_format = 'pdf_document')"

reporting/report.pdf: reporting/data_exploration.pdf gen/output/visual_directeffect.png
	Rscript -e "rmarkdown::render('reporting/report.Rmd', output_format = 'pdf_document')"

.PHONY: clean
clean:
	R -e "unlink('gen', recursive = TRUE)"
	R -e "unlink('data', recursive = TRUE)"
	R -e "unlink('reporting/*.html', recursive = TRUE)"
	R -e "unlink('reporting/*.pdf', recursive = TRUE)"
