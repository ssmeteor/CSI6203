#!/bin/bash
#Simon David Williams 10530539

# This script uses awk exclusively to check all user passwords in a text file to 
#  ensure they meet the following password strength rules: 
#     a. Must be eight (8) or more characters in length 
#     b. Must contain at least one (1) number 
#     c. Must contain at least one (1) uppercase letter 

# We skip the first (title) line then test the 3 conditions in the 'if' statement, 
#  Any passwords failing the test fall through to the else statement
awk '
    NR>1 { if ((length($2) >= 8) && ($2 ~ /.*[0-9].*/) && ($2 ~ /.*[A-Z].*/ ))
                {
                    printf $2 " - meets password strength requirements \n"
                }
            else 
                {
                    printf $2 " - does NOT meet password strength requirements \n"
                }
    }
' usrpwords.txt

exit 0