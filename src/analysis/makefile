# Default target: run full analysis and visualization

all: results/figures.pdf results/analysis_results.csv

include ../data-preparation/Makefile

# Step 1: Run statistical analysis
results/analysis_results.csv: ../data-preparation/processed_data/modeffect_data.csv analysis.R
	Rscript analysis.R

# Step 2: Generate visualizations
results/figures.pdf: results/analysis_results.csv visualization.R
	Rscript visualization.R