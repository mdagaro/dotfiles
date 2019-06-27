#!/bin/bash

GOTO_FILE="$HOME/scripts/.aliases"
GOTO_ERROR_CODE=0

__goto_print_command() {
    printf "    %-10s %-10s\n" "$1" "$2"
}

__goto_print_help() {
    printf "usage: goto [--help] [<alias> | <command> [...]]\n"
}

__goto_print_long_help() {
    print_help
    echo ""
    echo "If an alias is specified, this function changes the working directory to that alias."
    echo ""
    echo "  Commands"
    __goto_print_command "add" "create and add new aliases"
    __goto_print_command "delete" "delete an alias"
    __goto_print_command "help" "view this help message"
    __goto_print_command "list" "list currently defined aliases"

}


__goto_error() {
    echo "goto: $1" 1>&2
}

__goto_list() {

    # Print out the aliases sorted by name
    for k in "${!LOCATIONS[@]}"; do
        printf "    %-15s %-15s\n" "$k" "${LOCATIONS[$k]}"
    done | sort -n -k2
}

__update_autocomplete() {

    commands=$( IFS=$' '; echo "${!LOCATIONS[@]}")
    complete -W "$commands add delete list help" goto
    unset commands
}

# Updates the file with the current values in LOCATION
__goto_update() {
    local TEMP=".goto_temp"
    touch $TEMP
    for k in "${!LOCATIONS[@]}"; do
        echo "$k ${LOCATIONS[$k]}" >> $TEMP
    done
    cat $TEMP > $GOTO_FILE
}

__goto_add() {
    if [ -z $1 ] || [ "$1" == "show-all-if-ambiguous" ]; then
        __goto_error "no alias name provided. See 'goto add --help'"
    else
        LOCATIONS[$1]=$(pwd)
        echo "$1 ${LOCATIONS[$1]}" >> $GOTO_FILE
        __update_autocomplete
        echo "${LOCATIONS[$1]} successfully aliased to $1"
    fi
}

__goto_delete() {
    if [ -z $1 ] || [ "$1" == "show-all-if-ambiguous" ]; then
        __goto_error "no alias name provided. See 'goto delete --help'"
        GOTO_ERROR_CODE=1
    elif [[ -v "LOCATIONS[$1]" ]]; then
        unset LOCATIONS[$1]
        __goto_update
        __update_autocomplete
    else
        __goto_error "could not find alias '$1'"
        GOTO_ERROR_CODE=1
    fi

}


if [ $# -ge 1 ]; then

    # List aliases
    if [ "$1" == "list" ]; then
        __goto_list

    elif [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
        __goto_print_long_help

    # Add a new alias
    elif [ "$1" == "add" ]; then
        __goto_add $2

    # Delete an existing alias
    elif [ "$1" == "delete" ]; then
        __goto_delete $2

    # Go the location specified
    elif [ ${LOCATIONS["$1"]} ]; then
        cd ${LOCATIONS["$1"]}

    elif [ $1 == show-all-if-ambiguous ]; then
        __goto_print_help
    else
        __goto_error "'$1' is not aliased or a goto command. See 'goto --help'"
        GOTO_ERROR_CODE=1
    fi

fi

return $GOTO_ERROR_CODE
