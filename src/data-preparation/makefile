# Default target
all: modeffect_data.csv

# Step 1: Download data
data/raw_data/ratings.tsv.gz data/raw_data/crew.tsv.gz data/raw_data/name_basics.tsv.gz data/raw_data/title_basics.tsv.gz:
	Rscript download.R

# Step 2: Clean and merge
data/imdb_movies_dataset.csv: data/raw_data/ratings.tsv.gz data/raw_data/crew.tsv.gz data/raw_data/name_basics.tsv.gz data/raw_data/title_basics.tsv.gz
	Rscript clean_and_merge.R

# Step 3: Direct effect prep
directeffect_data.csv: data/imdb_movies_dataset.csv
	Rscript dataprep_directeffect.R

# Step 4: Moderation effect prep
modeffect_data.csv: directeffect_data.csv
	Rscript dataprep_modeffect.R
