# Allows reference to files that might not be there currently
.PHONY: clean

# Generates all artefacts after cleaning
all: <every main executable> 

# Removes artefacts from project file
clean: 
	rm -rf ~/work/task1data

# TASK 1 artefacts and dependencies
<t1_derived_data>: <r script that tidy's data>
	<shell commands>

	
# TASK 2 artefacts and dependencies
<t2_derived_data>: <r script that tidy's data>
	<shell commands>