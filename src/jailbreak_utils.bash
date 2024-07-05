#!/bin/bash

source ./echo_utils.bash
source ./process_utils.bash


jailbreak::is_goldhen_available() {
    nc -vz 192.168.2.2 3232
}

jailbreak::detect_goldhen() {
    local max_retries=${1:-10}
    local err_message="The console is either not connected to the network or it does not have Goldhen"

    proc::retry "jailbreak::is_goldhen_available" $max_retries 10 "$err_message"
    return $?
}
