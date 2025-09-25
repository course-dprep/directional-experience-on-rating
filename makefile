all: gen/output/visualization.pdf

# Step 1: Download data
data/name.basics.tsv.gz data/title_basics.tsv.gz data/crew.tsv.gz data/ratings.tsv.gz:
	R -e "dir.create('data', recursive = TRUE)"
	Rscript src/data-preparation/download.R

# Step 2: Clean and merge
gen/temp/clean_and_merge.csv: data/name.basics.tsv.gz data/title_basics.tsv.gz data/crew.tsv.gz data/ratings.tsv.gz src/data-preparation/clean_and_merge.R
	R -e "dir.create('gen/temp', recursive = TRUE)"
	Rscript src/data-preparation/clean_and_merge.R

# Step 3: Direct effect data prep
gen/temp/dataprep_directeffect.csv: src/data-preparation/dataprep_directeffect.R gen/temp/clean_and_merge.csv
	Rscript src/data-preparation/dataprep_directeffect.R

# Step 4: Moderate effect data prep
gen/temp/dataprep_modeffect.csv: src/data-preparation/dataprep_modeffect.R gen/temp/dataprep_directeffect.csv
	Rscript src/data-preparation/dataprep_modeffect.R

# Step 5: Analyzing the data
gen/output/analysis.csv: src/analysis/analysis.R gen/temp/dataprep_modeffect.csv
	R -e "dir.create('gen/output', recursive = TRUE)"
	Rscript src/analysis/analysis.R

# Step 6: Visualization of the output
gen/output/visualization.pdf: src/analysis/visualization.R gen/output/analysis.csv
	R -e "dir.create('gen/output', recursive = TRUE)"
	Rscript src/analysis/visualization.R

