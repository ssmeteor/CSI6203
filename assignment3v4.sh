#!/bin/bash
#Simon David Williams 10530539

# Function used for the user to select their search criteria
# ADVANCED FUNCTIONAL REQUIREMENT 1 created this function for multiple parameter calls
selectsearch() {
    # User now selects the search field and enters the search criteria
    echo -e "1. PROTOCOL"
    echo -e "2. SRC IP"
    echo -e "3. SRC PORT"
    echo -e "4. DEST IP"
    echo -e "5. DEST PORT"
    echo -e "6. PACKETS"
    echo -e "7. BYTES"
    while true; do
        read -p "Enter the number of the log field above you wish to search, i.e. [ 1, 2, 3, 4, 5, 6, 7 ]: " selfield
        #echo "You have entered $selfield"
        if [[ $selfield -gt 0 ]] && [[ $selfield -le 7 ]]; then
            break
        else
            echo "You must select a number of a field"
        fi
    done

    # Now search based on the field chosen
    case $selfield in
        1) read -p "Enter the PROTOCOL value to search for: " selval
        selfilter="\$3 ~ /"${selval}" */"  #space included
        ;;
        2) echo "Enter the SRC IP value to search for: "
        read -p "(Note the system will search for all SRC IP values beginnning with this): " selval
        selfilter="\$4 ~ /"${selval}"./"  #include and characters after entered value
        ;;
        3) read -p "Enter the SRC PORT value to search for: " selval
        selfilter="\$5 ~ /"${selval}"/"  # The exact value will be searched for 
        ;;
        4) echo "Enter the DEST IP value to search for: "
        read -p "(Note the system will search for all DEST IP values beginnning with this): " selval
        selfilter="\$6 ~ /"${selval}"./"  #include and characters after entered value
        ;;
        5) read -p "Enter the DEST PORT value to search for: " selval
        selfilter="\$7 ~ /"${selval}"/"  # The exact value will be searched for 
        ;;
        6)  while true; do # The PACKET value must be an integer so we need to test and request again if not!
                read -p "Enter the PACKET number value to search for: " selval
                if ! [[ "$selval" =~ ^[0-9]+$ ]]; then
                    echo -e "$selval incorrect, you must enter an integer only"
                else
                    break
                fi
            done
            # The user can search for records with PACKET greater, less than, equal or not equal
            echo -e "1. Equal"
            echo -e "2. Not Equal"
            echo -e "3. Less Than"
            echo -e "4. Greater Than"
            while true; do
                read -p "Enter the PACKET number comparison type, i.e. [ 1, 2, 3, 4 ]: " selcompare
                echo "You have entered $selcompare"
                if [[ $selcompare -gt 0 ]] && [[ $selcompare -le 4 ]]; then
                    break
                else
                    echo "You must select a number for the comparison operator"
                fi
            done
            case $selcompare in
                1) selfilter="\$8=="${selval} ;; # The exact value will be searched for 
                2) selfilter="\$8!="${selval} ;; # Any value not equal will be searched for 
                3) selfilter="\$8<"${selval}  ;; # Any value less than will be searched for 
                4) selfilter="\$8>"${selval}  ;; # Any value greater thenwill be searched for 
            esac
        ;;
        7)  while true; do # The BYTES value must be an integer so we need to test and request again if not!
                read -p "Enter the BYTES number value to search for: " selval
                if ! [[ "$selval" =~ ^[0-9]+$ ]]; then
                    echo -e "$selval incorrect, you must enter an integer only"
                else
                    break
                fi
            done
            # The user can search for records with BYTES greater, less than, equal or not equal
            echo -e "1. Equal"
            echo -e "2. Not Equal"
            echo -e "3. Less Than"
            echo -e "4. Great Than"
            while true; do
                read -p "Enter the BYTES number comparison type, i.e. [ 1, 2, 3,4 ]: " selcompare
                echo "You have entered $selcompare"
                if [[ $selcompare -gt 0 ]] && [[ $selcompare -le 4 ]]; then
                    break
                else
                    echo "You must select a number for the comparison operator"
                fi
            done
            case $selcompare in
                1) selfilter="\$9=="${selval} ;; # The exact value will be searched for 
                2) selfilter="\$9!="${selval} ;; # Any value not equal will be searched for 
                3) selfilter="\$9<"${selval}  ;; # Any value less than will be searched for 
                4) selfilter="\$9>"${selval}  ;; # Any value greater thenwill be searched for 
            esac
        ;;
    esac
}

# START ......................................................................
#
# Get a list of log files to present to the user
declare -a logs
patt="serv_acc_log*.csv"  

# Get all files matching the pattern
for file in $patt; do
    logs+=($(basename $file))
done
count=${#logs[*]}

# Exit if no files found
if (( $count==0 )); then
    echo "No matching log files found"
    exit 1
fi
echo -e "\t"
echo -e "$count log file(s) found.\n"

# Loop to allow the user to search again...
while true; do
    # List the log files found to the user
    # The 'ie' variable is used in the prompt to indicate to the user the number to be used for the log file
    #   so make sure it only containd the available log files number
    ie="[A,"
    mennum=1
    for file in "${logs[@]}"; do
        echo -e "$mennum. $file"
        if (( $mennum==1 )); then
            ie+=" 1"
        elif (( $mennum==$count )); then     
            ie+=" or $mennum ]: "
        else
            ie+=", $mennum"
        fi 
        ((mennum++)) # increment the log file number
    done 
    # ADVANCED FUNCTIONAL REQUIREMENT 2 - Search All log files
    # Get the user to select all or a single log file
    while true; do
        read -p "Enter the number of the file in the menu above you wish to search or A for all, i.e. $ie " sel
        if [[ $sel =~ ^[A|a]$ ]]; then  # All files selected
            selfile=$( echo "${logs[*]}") # This will list all log files in single string space separated
            paramlimit=1 # if searching all files only one parameter can be entered
            break
        elif [[ $sel -gt 0 ]] && [[ $sel -le $count ]]; then
            selfile=${logs[sel-1]}  # Set $selfile to the log file selected by the user
            paramlimit=3  # User can enter up to 3 parameters if searching a single file
            break
        else
            echo "You must select a number of a file"
        fi
    done
    echo -e "You have selected log file(s): $selfile"
    echo -e "\t"

    # ADVANCED FUNCTIONAL REQUIREMENT 1 - Multiple Search requirements
    # ADVANCED FUNCTIONAL REQUIREMENT 2 - Only one parameter if searching All log files
    # Get the search parameters (user can select up to 3 if searching 1 file or 1 parameter if searching all files)
    for (( i=1; i<=$paramlimit; i++ )); do
        # Get another parameter if parameter limit not reached
        if [[ i -gt 1 ]]; then
            read -p "Enter 'Y' to select another search parameter (upto $paramlimit allowed): " selYN
            if [[ ! "$selYN" =~ ^[Y|y]$ ]]; then
                break
            fi
        fi

        selectsearch  # This function will allow the user to enter a search parameter

        # append new search criteria in the $selfilter varible to $selfilters
        if [[ i -eq 1 ]]; then 
            selfilters=${selfilter}
        else
            selfilters+=" && "${selfilter}
        fi
        
    done

    echo -e "\t"
    # Now get the name of the file to save the search results to
    while true; do
        read -p "Enter the name of the file to save the search result to: " seloutput
        if [ -f "$seloutput" ]; then
            echo "$seloutput already exists, use another file name"
        else 
            break
        fi
    done

    # Now read the file using the filter variable to use the user entered parameters
    # NR==1 is used to print the heading line of the first file
    # $selfilters is used to hold the parameters entered by the user
    # FNR!=1 is used to not print the heading line of other files (if somehow the selected filter matches!)
    # $13 !~ /normal/ is used to never print lines CLASS=normal
    # $selfile is the file(s) selected by the user (may be all log files in the folder)
    echo "Starting Search...."
    awk 'BEGIN {FS=","; IGNORECASE=1} 
        NR==1 || ('"$selfilters"' && FNR!=1 && $13 !~ /normal/ )  { print $0 }    
        ' $selfile > $seloutput
    
    # Display the formatted search results to the user from the outut file of the previous AWK statement
    #  the file includes a header so we just need to format the output
    echo -e "\t"
    echo -e "Search results...."
    awk 'BEGIN {FS="," }
        { printf " %-12s %-10s %-10s %-12s %-10s %-12s %-10s %-10s %-10s %-10s %-10s %-10s %-10s \n", 
           $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' $seloutput

    # Ask the user if they wat to search again
    echo -e "\t"
    read -p "Enter 'Y' to search again: " selYN
    if [[ ! "$selYN" =~ ^[Y|y]$ ]]; then
        break
    fi

done

exit 0