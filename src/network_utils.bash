#!/bin/bash

source ./echo_utils.bash
source ./process_utils.bash

net::stop() {
    echo::nok Network Reset
    ip addr flush dev $INTERFACE
    ip link set $INTERFACE down
    echo::ok "   -> Down"
}

net::start() {
    ip addr flush dev $INTERFACE
    ip link set $INTERFACE up
    echo::ok "   -> UP"
    ip addr add 192.168.2.1/24 dev $INTERFACE
    echo::ok "   -> Done"
}

net::wait_conn() {
    echo::nok Waiting for Link
    while [[ ! $(ip link show $INTERFACE) == *"state UP"* ]]
    do
        wait_cmd
    done
    echo::ok "   -> Link Found"
}

net::restart() {
    echo::ok "***************"
    echo::ok " Network Reset "
    echo::ok "***************"

    net::stop
    net::start
    net::wait_conn
}

net::firewall_stop() {
    echo::nok "Stoping Firewall"
    iptables -t nat -L POSTROUTING --line-numbers | \
        grep 192.168.2.0 | \
        cut -d ' ' -f1 | \
        sort -nr | \
        xargs -L 1 -d '\n' -r iptables -t nat -D POSTROUTING
    ufw --force reset
    ufw --force disable
    echo::ok "  -> Done"
}

net::firewall_start() {
    echo::nok Configure Firewall
    ufw enable
    iptables -t nat -A POSTROUTING -s 192.168.2.0/24 ! -d 192.168.2.0/24 -j MASQUERADE
    echo::ok "   -> Done"
}

net::pppoe_start() {
    echo::nok Start PPPOE Server
    pppoe-server -I $INTERFACE -T 60 -N 1 -C PPPWN -S PPPWN -L 192.168.2.1 -R 192.168.2.2
    wait_cmd
    echo::ok "   -> Server Running"
}

net::pppoe_stop() {
    killall pppoe-server
}
