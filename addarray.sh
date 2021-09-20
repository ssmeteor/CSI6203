#!/bin/bash
#Simon David Williams 10530539

# This script employs a c-style loop to calculate the sum of two assignment scores as they appear ordinally in separate arrays

# Create the 2 read-only arrays to be used and set their values
declare -ar ass1=(12 18 20 10 12 16 15 19 8 11)
declare -ar ass2=(22 29 30 20 18 24 25 26 29 30)

# Both arrays are the same length so just use the first to work out how many entries 
len=${#ass1[*]}

# Loop through the arrays and add and print
for (( i=0; i<${len}; i++ )); do 
    # Extract the values from the arrays and add together
    ass1val=${ass1[$i]}
    ass2val=${ass2[$i]}
    totval=$((ass1val+ass2val))
    # Print the total for this student
    echo -e "    Student_$((i+1)) Result:\t$totval"
done

exit 0