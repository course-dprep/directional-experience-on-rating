# Default target: voert alles uit tot het laatste bestand
all: processed_data/modeffect_data.csv

# Step 1: Download data
raw_data/data.csv:  # zorgt dat de data wordt gedownload in raw_data
	Rscript download.R

# Step 2: Clean and merge
processed_data/cleaned_data.csv: raw_data/data.csv  # maakt schoon bestand
	Rscript clean_and_merge.R

# Step 3: Direct effect prep
processed_data/directeffect_data.csv: processed_data/cleaned_data.csv  # bereidt direct effect data
	Rscript dataprep_directeffect.R

# Step 4: Moderation effect prep
processed_data/modeffect_data.csv: processed_data/directeffect_data.csv  # bereidt moderatie effect data
	Rscript dataprep_modeffect.R

