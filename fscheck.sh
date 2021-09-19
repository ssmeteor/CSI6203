#Simon David Williams 10530539
#!/bin/bash

# This script script that retrieves the following information about a file the user enters: 
#   a. Its size in kilobytes 
#   b. The number of words it contains 
#   c. The date/time it was last modified 

# Function to display the properties
getprop()  {
    kilobytes=$(du -ak < $1) # File size in kilobyes
    wordcount=$(wc -w < $1)  # Words in the file
    modified=$(date -r $1 +"%Y-%m-%d %H:%M:%S") # modeifed date formatted and including seconds
    # Display the properties
    echo "The file $1 contains $wordcount words and is ${wordcount}K in size and was last modified $modified"
}

# Get the file name from the user
read -p 'Enter the file name: ' filename
if ! [[ -f $filename ]]; then
    # Warn the user if the file does not exist
    echo "File $filename not found"
    exit 1
else
    getprop $filename  # Call the property display function with the file entered
fi