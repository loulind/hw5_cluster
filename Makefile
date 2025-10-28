# Allows reference to files that might not be there currently
.PHONY: all clean dirs

# Generates all artefacts in project
all: task1data/df_n2.csv\
 task1data/df_n3.csv\
 task1data/df_n4.csv\
 task1data/df_n5.csv\
 task1data/df_n6.csv\
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
 task2data/df_maxradius10.csv\
 task1figures/pred_clstr_cnts.png\
 task2figures/pred_clstr_cnts2.png

# Removes artefacts from project file output directories
clean: 
	rm -rf task1data
	rm -rf task1figures
	rm -rf task2data
	rm -rf task2figures
	mkdir -p task1data
	mkdir -p task1figures
	mkdir -p task2data
	mkdir -p task2figures

dirs:
	mkdir -p task1data
	mkdir -p task1figures
	mkdir -p task2data
	mkdir -p task2figures
	
# "| dirs" forces directories to be created first
# TASK 1 targets
# data
task1data/df_n2.csv task1data/df_n3.csv task1data/df_n4.csv\
 task1data/df_n5.csv task1data/df_n6.csv: derived_data.R | dirs
	Rscript derived_data.R

# figures
task1figures/pred_clstr_cnts.png:\
 task1data/df_n2.csv\
 task1data/df_n3.csv\
 task1data/df_n4.csv\
 task1data/df_n5.csv\
 task1data/df_n6.csv | dirs
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
 task2data/df_maxradius10.csv: derived_data2.R | dirs
	Rscript derived_data2.R

# figures
task2figures/pred_clstr_cnts2.png: cluster_spectral.R | dirs
	Rscript cluster_spectral.R