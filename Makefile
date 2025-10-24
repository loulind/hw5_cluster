# Vars that contain executables
T1DATA = task1data/df_n2.csv task1data/df_n3.csv\
 task1data/df_n4.csv task1data/df_n5.csv task1data/df_n6.csv
T1FIGURES = 

T2DATA =
T2FIGURES = 

# Allows reference to files that might not be there currently
.PHONY: all clean

# Generates all artefacts after cleaning
all: $(T1DATA) $(T2DATA) $(T1FIGURES) $(T2FIGURES)

# Removes artefacts from project file
clean: 
	rm -rf task1data/*
	rm -rf task1figures/*
	rm -rf task2data/*
	rm -rf task2figures/*

# TASK 1 artefacts and dependencies
$(T1DATA): derived_data.R
	mkdir -p task1data
	Rscript derived_data.R
	
$(T1FIGURES): $(T1DATA)
	mkdir -p task1figures
	Rscript cluster_kmeans.R

# TASK 2 artefacts and dependencies
$(T2DATA): derived_data.R
	mkdir -p task2data
	Rscript derived_data.R
	
$(T2FIGURES): $(T2DATA)
	mkdir -p task2figures
	Rscript cluster_kmeans.R