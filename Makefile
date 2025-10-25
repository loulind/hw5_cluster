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
# data
task1data/df_n2 task1data/df_n3 task1data/df_n4\
 task1data/df_n5 task1data/df_n6: derived_data.R
	Rscript derived_data.R

# figures
task1figures/pred_clstr_cnts:\
 task1data/df_n2\
 task1data/df_n3\
 task1data/df_n4\
 task1data/df_n5\
 task1data/df_n6
	Rscript cluster_kmeans.R


# TASK 2 targets
# data
task2data/df_maxradius0.csv\
 task2data/df_maxradius1.csv\
 task2data/df_maxradius2.csv\
 task2data/df_maxradius3.csv\
 task2data/df_maxradius4.csv\
 task2data/df_maxradius5.csv\
 task2data/df_maxradius6.csv\
 task2data/df_maxradius7.csv\
 task2data/df_maxradius8.csv\
 task2data/df_maxradius9.csv\
 task2data/df_maxradius10.csv: derived_data2.R
	Rscript derived_data2.R

# figures
task2figures/pred_clstr_cnts2.png: cluster_spectral.R
	Rscript cluster_spectral.R