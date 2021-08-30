#Simon David Williams 10530539
#!/bin/bash

# This script counts the number of files and child directories within a specified directory according to a specified property. 

# Integer variables used to contain the counts of files and directories
declare -i fileWithData=0 fileNoData=0 DirWithFiles=0 DirNoFiles=0

# Loop through each file or directory in the directory entered by the user
for item in $1*; do
    # If its a file....
    if [ -f $item ]; then
        # If the file is not empty
        if [ -s $item ]; then
            ((fileWithData++))  # Add to count of files with data
        else
            ((fileNoData++))  # Add to count of files with  nodata
        fi
    else # Its a directory
        filecnt=$(ls $item | wc -l) # Count the files in this directory
        if [ $filecnt -gt 0 ]; then
            ((DirWithFiles++)) # Add to count of directories with files
        else
            ((DirNoFiles++)) # Add to count of directories with no files
        fi
    fi
done

# Change to thr directory entered by the user and store the path so it can be displayed
cd $1
newdir=$(pwd) # Store the names of the directory we will query

# Display the directory, file and folder stats
echo "The $newdir directory contains:"

echo "$fileWithData files that contain data"
echo "$fileNoData files that are empty"
echo "$DirWithFiles non-empty directories"
echo "$DirNoFiles empty directories"

exit 0