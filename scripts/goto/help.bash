#!/bin/bash

__goto_print_command() {
    printf "    %-10s %-10s\n" "$1" "$2"
}

__goto_print_short_help() {
    printf "usage: goto [--help] <alias>\n"
    printf "   or: goto <command> [--help] [...]\n"
}

__goto_print_long_help() {
    __goto_print_short_help
    echo ""
    echo "If an alias is specified, this function changes the working directory to that alias."
    echo ""
    echo "  Commands"
    __goto_print_command "add" "create and add new aliases"
    __goto_print_command "delete" "delete an alias"
    __goto_print_command "help" "view this help message"
    __goto_print_command "list" "list currently defined aliases"

}

__goto_print_add_help() {
    echo "add help goes here"
}

__goto_print_delete_help() {
    echo "delete help goes here"
}

__goto_print_list_help() {
    echo "list help goes here"
}

__goto_help() {
    case $1 in
        add)
            __goto_print_add_help
            ;;
        delete)
            __goto_print_delete_help
            ;;
        list)
            __goto_print_list_help
            ;;
        short)
            __goto_print_short_help
            ;;
        long)
            __goto_print_long_help
    esac

}
