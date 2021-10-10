#!/bin/bash
#Simon David Williams 10530539
#GLOBIGNORE="*"  # Don't exand an asterisk

declare -a logs
patt="serv_acc_log.+csv$"
mennum=1

for file in ./*; do
    #echo $file
    if [[ $file =~ $patt ]]; then
        logs+=($(basename $file))
    fi
done

count=${#logs[*]}
#echo $count
# Exit if no files found
if (( $count==0 )); then
    echo "No matching log files found"
    exit 1
fi
echo -e "\t"
echo -e "The logs array contains $count files.\n"

# List the log files found to the user
# The 'ie' variable is used in the prompt to indicate to the user the number to be used for the log file
#   so make sure it only containd the available log files number
ie="["
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
# Get the user to select a log file
while true; do
    read -p "Enter the number of the file in the menu above you wish to search, i.e. $ie " sel
    #echo "You have entered $sel"
    if [[ $sel -gt 0 ]] && [[ $sel -le $count ]]; then
        break
    else
        echo "You must select a number of a file"
    fi
done

# Set $selfile to the log file selected by the user
selfile=${logs[sel]}
echo -e "You have selected log file: $selfile"

echo -e "\t"
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
    echo "You have entered $selfield"
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
        echo -e "4. Great Than"
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

echo "\$selval=" $selval
echo -e "\$selfilter=" "$selfilter"

# Now read the file using the filter variable to use the user entered parameters
awk 'BEGIN {FS=","} 
    NR==1 || ('"$selfilter"' && $13 !~ /normal/ )  { print $0 }    
    ' $selfile > $seloutput

# Display the formatted search results to the user from the saved file
awk 'BEGIN {FS="," }
     { printf "%-10s %-10s %-10s %-12s %-10s %-12s %-10s %-10s %-10s %-10s %-10s %-10s %-10s \n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}
    ' $seloutput

exit 0