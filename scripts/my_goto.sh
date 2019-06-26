#!/bin/bash

FILE="$HOME/scripts/.aliases"
GOTO_ERROR_CODE=0
echo $GOTO_ERROR_CODE
echo "potato"

print_command() {
    printf "    %-10s %-10s\n" "$1" "$2"
}

print_help() {
    printf "usage: goto [--help] [<alias> | <command> [...]]\n"
}

print_long_help() {
    print_help
    echo ""
    echo "If an alias is specified, this function changes the working directory to that alias."
    echo ""
    echo "  Commands"
    print_command "add" "create and add new aliases"
    print_command "delete" "delete an alias"
    print_command "help" "view this help message"
    print_command "list" "list currently defined aliases"

}


error() {
    echo "goto: $1" 1>&2
}

list() {

    # Print out the aliases sorted by name
    for k in "${!LOCATIONS[@]}"; do
        printf "    %-15s %-15s\n" "$k" "${LOCATIONS[$k]}"
    done | sort -n -k2
}

# Updates the file with the current values in LOCATION
update() {
    local TEMP=".goto_temp"
    touch $TEMP
    for k in "${!LOCATIONS[@]}"; do
        echo "$k ${LOCATIONS[$k]}" >> $TEMP
    done
    cat $TEMP > $FILE
}

add() {
    if [ -z $1 ] || [ "$1" == "show-all-if-ambiguous" ]; then
        error "no alias name provided. See 'goto add --help'"
    else
        LOCATIONS[$1]=$(pwd)
        echo "$1 ${LOCATIONS[$1]}" >> $FILE
        echo "${LOCATIONS[$1]} successfully aliased to $1"
    fi
}

delete() {
    if [ -z $1 ] || [ "$1" == "show-all-if-ambiguous" ]; then
        error "no alias name provided. See 'goto delete --help'"
        GOTO_ERROR_CODE=1
    elif [[ -v "LOCATIONS[$1]" ]]; then
        unset LOCATIONS[$1]
        update
    else
        error "could not find alias '$1'"
        GOTO_ERROR_CODE=1
    fi

}

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

if [ $# -ge 1 ]; then

    # List aliases
    if [ "$1" == "list" ]; then
        list

    elif [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
        print_long_help

    # Add a new alias
    elif [ "$1" == "add" ]; then
        add $2

    # Delete an existing alias
    elif [ "$1" == "delete" ]; then
        delete $2

    # Go the location specified
    elif [ ${LOCATIONS["$1"]} ]; then
        cd ${LOCATIONS["$1"]}

    elif [ $1 == show-all-if-ambiguous ]; then
        print_help
    else
        error "'$1' is not aliased or a goto command. See 'goto --help'"
        GOTO_ERROR_CODE=1
    fi

fi

# Unset functions and variables
unset -f error
unset -f print_help
unset -f print_long_help
unset -f list
unset -f add
unset -f delete
unset -f update
unset -f print_command
unset FILE
echo $GOTO_ERROR_CODE
return $GOTO_ERROR_CODE
