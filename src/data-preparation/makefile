# Default target: runs everything up to the last file
all: processed_data/modeffect_data.csv

# Step 1: Download data
raw_data/data.csv:  # ensures the data is downloaded into raw_data
	Rscript download.R

# Step 2: Clean and merge
processed_data/cleaned_data.csv: raw_data/data.csv  # creates cleaned file
	Rscript clean_and_merge.R

# Step 3: Direct effect prep
processed_data/directeffect_data.csv: processed_data/cleaned_data.csv  # prepares direct effect data
	Rscript dataprep_directeffect.R

# Step 4: Moderation effect prep
processed_data/modeffect_data.csv: processed_data/directeffect_data.csv  # prepares moderation effect data
	Rscript dataprep_modeffect.R
