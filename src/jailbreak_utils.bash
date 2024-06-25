#!/bin/bash

source ./echo_utils.bash

jailbreak::detect_goldhen() {
    local max_retries=$1
    let "retries=0"
    while [[ $retries -lt $max_retries ]]
    do
      if nc -vz 192.168.2.2 3232
      then
        return 0
      else
        let "retries=retries + 1"
        echo::nok "The console is either not connected to the network or it does not have Goldhen"
        echo "Wait 10 seconds before the next retry (${retries} of ${max_retries})"
        sleep 10
      fi
    done
    return 1
}
