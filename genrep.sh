#!/bin/bash
#Simon David Williams 10530539

# This script  uses grep, sed and awk in combination to extract specific information from a .html file 
#  and echo it to the terminal as a formatted summary 

# The following variables are used to make the sed statement more readable
pre="<tr><td>"
post="<\/td><\/tr>"
mid="<\/td><td>"

# Read the file and pipe it to grep to filter for the table rows used for the stats
#  the use sed to remove the mark up ... finally pip to awk to sum the 3 months and display the results 
cat attacks.html | grep "<td>" | sed -e "s/^$pre//g; s/$post$//g; s/$mid/ /g" | awk 'BEGIN {printf "%-20s %-20s \n", "Attacks", "Instances(Q3)"} {atot=($2+$3+$4); printf "%-20s %-10s \n", $1, atot }'

exit 0