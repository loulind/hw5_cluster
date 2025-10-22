# Allows reference to files that might not be there currently
.PHONY: clean

# Removes artifacts from project file
clean:
	rm -rf <directory name>
	rm <indiv file name>

# TASK 1 artefacts and dependencies
<t1_derived_data>: <r script that tidy's data>
	<shell commands>

	
# TASK 2 artefacts and dependencies
<t2_derived_data>: <r script that tidy's data>
	<shell commands>