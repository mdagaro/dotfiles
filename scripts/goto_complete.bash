#!/bin/bash

FILE="$HOME/scripts/.aliases"
# Initialization script

declare -A LOCATIONS
if [ ${#LOCATIONS[@]} == 0 ]; then
    touch $FILE
    # Read from FILE
    while IFS= read -r line; do
        vars=($line)
        LOCATIONS[${vars[0]}]=${vars[1]}
    done < $FILE
fi

commands=$( IFS=$' '; echo "${!LOCATIONS[@]}")
echo "$commands"
complete -W "$commands add delete list help" goto
