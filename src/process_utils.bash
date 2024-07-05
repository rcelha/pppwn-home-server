#!/bin/bash

source ./echo_utils.bash

wait_cmd() {
    coproc read -t 10 && wait "$!" || true
}

proc::retry() {
  local function=$1
  local c=${2:-3}
  local timeout=${3:-10}
  local message=${4:-"'$function' failed"}

  for i in $(seq 0 $c)
  do
    if $function
    then
      return 0
    else
      echo::debug $message
      echo::debug "Wait $timeout seconds before the next retry (${i} of ${c})"
      sleep $timeout
    fi
  done

  echo::nok "Error: '$function' has failed too many times"
  echo::nok "Error: $message"
  return 1
}
