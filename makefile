
all: gen/output/visualization.pdf 

#Step 1: Download data
data/name.basics.tsv.gz data/title_basics.tsv.gz  data/crew.tsv.gz data/ratings.tsv.gz: src/data-preparation/download.R
	R -e "dir.create('$(data)' recursive = T)"
	Rscript src/data-preparation/download.R

#step 2: Clean and merge
gen/temp/clean_and_merge.csv: src/data-preparation/clean_and_ merge.csv data/name.basics.tsv.gz data/title_basics.tsv.gz  data/crew.tsv.gz data/ratings.tsv.gz
	R -e "dir.create('$(gen/temp)' recursive = T)"
	Rscript scr/data-preparation/clean_and_merge.csv

#step 3: direct effect data prep
gen/temp/dataprep_directeffect.csv: src/data-preparation/dataprep_directeffect.R src/data-preparation/clean_and_ merge.csv
	R -e "dir.create('gen/temp/', recursive = T)"
	Rscript src/data-preparation/dataprep_directeffect.R

# step 4: moderate effect data prep
gen/temp/dataprep_modeffect.csv: src/data-preparation/dataprep_modeffect.R src/data-preparation/dataprep_directeffect.R
	R -e "dir.create('gen/temp/', recursive = T)"
	Rscript src/data-preparation/dataprep_modeffect.R

#step 5: analyzing the data
gen/output/analysis.csv: src/analysis/analysis.R gen/temp/dataprep_modeffect.csv
	R -e "dir.create('gen/output/', recursive = T)"
	Rscript src/analysis/analysis.R

#step 6: visualization of the output
gen/output/visualization.pdf: src/analysis/visualization.R src/analysis/analysis.R
	R -e "dir.create('gen/output/', recursive = T)"
	Rscript src/analysis/visualization.R
