#!/bin/bash
#Simon David Williams 10530539

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
echo -e "The logs array contains $count files.\n"

ie="["
for file in "${logs[@]}"; do
    echo -e "$mennum $file"
    if (( $mennum==1 )); then
        ie+=" 1"
        # if [ $mennum -eq $count]; then
        #     ie+="]"
        # fi
    elif (( $mennum==$count )); then     
        ie+=" or $mennum ]: "
    else
        ie+=", $mennum"
    fi 
    #echo -e "$ie"
    ((mennum++))
done 
echo -e "\t"
while true; do
    read -p "Enter the number of the file in the menu above you wish to search, i.e. $ie " sel
    echo "You have entered $sel"
    if [[ $sel -gt 0 ]] && [[ $sel -le $count ]]; then
        break
    else
        echo "You must select a number of a file"
    fi
done



exit 0