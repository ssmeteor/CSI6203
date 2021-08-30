#Simon David Williams 10530539
#!/bin/bash

# This script allows the user to search for specific lines in a server access log 
# according to a pattern they provide and have these lines written to a new file for further use

# Loop until the user exits
while true; do 
    # Get the user to enter the search parameters
    read -p "Enter the pattern to be searched for: " usrpattern
    read -p "Enter 'Y' to use a whole word match or 'N': " wholeword
    read -p "Enter 'Y' to search for lines containing the pattern or 'N' for lines not containing the pattern: " patternexists

    # Format the grep options for the Whole word match and to match lines not matching the pattern (inverted)
    grepusroptions=""
    if [ $wholeword = 'Y' ]; then # Match whole words only
        grepusroptions+='w'
    fi
    if [ $patternexists = 'N' ]; then # Use the invert option
        grepusroptions+='v'
    fi
    
    #echo " options=$grepusroptions pattern=$usrpattern"

    # Count any pattern matches into a variable
    cntMatch=$( grep -wci"$grepusroptions" "$usrpattern" access_log.txt ) # options are wc=count, i=case insensitive plus users options

    if [ $cntMatch -eq 0 ]; then # No matches
        echo -e "\nNo matches found"
    else
        echo -e "\n$cntMatch matches found\n" 
        grep -in"$grepusroptions" "$usrpattern" access_log.txt # echo the matched lines with line number
    fi

    # loop through again?
    echo ""
    read -p $"Press enter to try again or any character to exit: " doagain
    if [ ! -z $doagain ]; then # character entered so break out of loop
        break
    fi
done

exit 0