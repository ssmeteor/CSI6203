#Simon David Williams 10530539
#!/bin/bash

# This script prompts the user to enter a two digit numeric code (integer) that is either 20 or 40.
# No other input is accepted

# loop until the user enters a correct value
while true; do # begin loop

    # Ask the user to enter 20 or 40
    read -p "enter a two digit numeric code (integer) that is either 20 or 40: " intEntered
    
    # Test for an integer that is 20 or 40
    if [[ $intEntered =~ ^[0-9]+$ ]] && [ $intEntered -eq 20 -o $intEntered -eq 40 ]; then
        echo "Congratulations, you have entered a valid integer that is either 20 or 40 "
        break # valid number entered so exit loop
    else    
        echo -e "Sorry, the value you have entered is not a vaid integer\n" # loop again
    fi
done

exit 0