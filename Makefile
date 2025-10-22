# Allows reference to files that might not be there currently
.PHONY: clean

# Removes artifacts from project file
clean:
	rm -rf <directory name>
	rm <indiv file name>

<derived data>: <r script that tidy's data>
	<shell commands>