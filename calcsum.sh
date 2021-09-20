#!/bin/bash
#Simon David Williams 10530539

# This script will take 3 parameters (integers) and sum them diplaying the total
# If the total exceeds 30 then a warning message is displayed

# Sum the parameters entered on the command line
let intTotal=$1+$2+$3

# If the sum total is greater than 30 display a warning otherwise display the sum total
if [ $intTotal -gt 30 ]; then
    echo "Sum exceeds maximum allowable"
else
    echo "The sum of $1 and $2 and $3 is $intTotal "
fi

exit 0