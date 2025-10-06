# Default target: runs everything up to the last file
all: ../../gen/temp/imdb_movies.csv

#Step 1: Download data
../../data/raw_data/title.ratings.tsv.gz ../../data/raw_data/title.crew.tsv.gz ../../data/raw_data/name.basics.tsv.gz ../../data/raw_data/title.basics.tsv.gz: ../../src/data-preparation/download.R
	R -e "dir.create('../../data/raw_data', recursive = TRUE)"
	Rscript ../../src/data-preparation/download.R

#step 2: Clean and merge
../../gen/temp/imdb_movies.csv: ../../data/raw_data/title.ratings.tsv.gz ../../data/raw_data/title.crew.tsv.gz ../../data/raw_data/name.basics.tsv.gz ../../data/raw_data/title.basics.tsv.gz ../../src/data-preparation/clean_and_merge.R
	R -e "dir.create('../../gen/temp', recursive = TRUE)"
	Rscript ../../src/data-preparation/clean_and_merge.R

# Step 3: Direct effect data prep
gen/temp/dataprep_directeffect.csv: src/data-preparation/dataprep_directeffect.R gen/temp/clean_and_merge.csv
	Rscript src/data-preparation/dataprep_directeffect.R

# Step 4: Moderate effect data prep
gen/temp/dataprep_modeffect.csv: src/data-preparation/dataprep_modeffect.R gen/temp/dataprep_directeffect.csv
	Rscript src/data-preparation/dataprep_modeffect.R
