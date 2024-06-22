#!/bin/bash

echo::ok() {
    echo -e "\033[32m$@\033[0m"
}

echo::nok() {
    echo -e "\033[31m$@\033[0m"
}
