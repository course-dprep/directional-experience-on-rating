# Define directories
OUTPUT = gen/output
TEMP = gen/temp
DATA = data
SRC_ANALYSIS = src/analysis
SRC_DATAPREP = src/data-preparation








-----------------------------------------------------
# Default target: run full analysis and visualization

all: results/figures.pdf results/analysis_results.csv

# Step 1: Run statistical analysis
results/analysis_results.csv: analysis.R
	$(MAKE) -C ../data-preparation ../data-preparation/processed_data/dataprep_modeffect.csv
	mkdir -p results
	Rscript analysis.R

# Step 2: Generate visualizations
results/figures.pdf: results/analysis_results.csv visualization.R
	mkdir -p results
	Rscript visualization.R
