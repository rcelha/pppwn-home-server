#!/bin/bash

echo::ok() {
    echo -e "\033[32m$@\033[0m"
}

echo::nok() {
    echo -e "\033[31m$@\033[0m"
}

echo::debug() {
    local LINENO=${BASH_LINENO[0]:-""}
    local SOURCE=${BASH_SOURCE[1]:-""}
    local PREFIX=""

    if [[ $LINENO  != "" && $SOURCE != "" ]]
    then
        PREFIX="${SOURCE}:${LINENO}: "
    fi
    echo -e "\033[2;37m$PREFIX$@\033[0m"
}

echo::_color_table() {
    local text=${@:-SAMPLE}
    for i in {30..40}
    do
        echo -n "| "
        for j in {0..3}
        do
            echo -n "033[${j};${i}m="
            echo -n -e "\033[${j};${i}m$text\033[0m | "
        done
        echo
    done
}
