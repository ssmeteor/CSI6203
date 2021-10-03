#!/bin/bash
#Simon David Williams 10530539

declare -a logs
patt="serv_acc_log.+scv$"
mennum=1

for file in ./*; do
    if [[ $file =~ $patt ]]; then
        logs+=($(basename $file))
    fi
done

count=${#logs[*]}
echo -e "The logs array contains $count files.\n"

for file in "${logs[@]}"; do
    echo -e "$mennum $file"
    ((mennum++))
done
echo -e "\t"
read -p "Enter the number of the file in the menu above you wish to search, i.e. [1,2,3,4 or 5] " sel
echo "You have entered $sel"

exit 0