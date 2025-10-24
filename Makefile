# Allows reference to files that might not be there currently
.PHONY: all clean

# Generates all artefacts after cleaning
all:\
 task1figures/pred_clstr_cnts.png
 task2figures/pred_clstr_cnts2.png

# Removes artefacts from project file output directories
clean: 
	rm -rf task1data/*
	rm -rf task1figures/*
	rm -rf task2data/*
	rm -rf task2figures/*

# TASK 1 targets
task1data/df_n2 task1data/df_n3 task1data/df_n4\
 task1data/df_n5 task1data/df_n6: derived_data.R
	Rscript derived_data.R

task1figures/pred_clstr_cnts:\
 task1data/df_n2\
 task1data/df_n3\
 task1data/df_n4\
 task1data/df_n5\
 task1data/df_n6
	Rscript cluster_kmeans.R


# TASK 2 targets
task2data/t2_data.csv task2figures/scatter_3d.png: derived_data2.R
	Rscript derived_data2.R
	
task2figures/pred_clstr_cnts2.png: 
	Rscript cluster_kmeans.R