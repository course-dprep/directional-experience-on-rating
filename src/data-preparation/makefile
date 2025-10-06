# Default target: runs everything up to the last file
all: gen/temp/imdb_movies_direct.csv gen/temp/imdb_movies_mod.csv 

# Step 1: Download data
gen/temp/download_complete: download.R
	R --vanilla < download.R

# Step 1a: CSV files stored in gen/temp/download_complete makes sure it only runs once
gen/temp/ratings.csv gen/temp/crew.csv gen/temp/name_basics.csv gen/temp/title_basics.csv: gen/temp/download_complete

# Step 2: Clean and merge
gen/temp/imdb_movies.csv: gen/temp/ratings.csv gen/temp/crew.csv gen/temp/name_basics.csv gen/temp/title_basics.csv clean_and_merge.R
	R --vanilla < clean_and_merge.R

#Step 3: Direct effect data prep
gen/temp/imdb_movies_direct.csv: gen/temp/imdb_movies.csv dataprep_directeffect.R
	R --vanilla < dataprep_directeffect.R

#Step 4: Moderate effect data prep
gen/temp/imdb_movies_mod.csv: gen/temp/imdb_movies.csv dataprep_modeffect.R
	R --vanilla < dataprep_modeffect.R

