#!/bin/bash

wait_cmd() {
    coproc read -t 10 && wait "$!" || true
}
