.PHONY: all clean

all: gen/temp/visual_directeffect.png gen/temp/visual_moderatingeffect.png

gen/temp/visual_directeffect.png gen/temp/visual_moderatingeffect.png: ../../gen/temp/imdb_movies_direct.csv ../../gen/temp/imdb_movies_mod.csv analysis.R
	Rscript --vanilla analysis.R