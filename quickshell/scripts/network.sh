#!/bin/bash
type=$(nmcli -t -f TYPE,STATE d status 2>/dev/null | grep ':connected' | head -1 | cut -d: -f1)
if [ "$type" = "wifi" ]; then
    info=$(nmcli -t -f ACTIVE,SIGNAL,SSID d w list 2>/dev/null | grep '^yes:')
    signal=$(echo "$info" | cut -d: -f2)
    ssid=$(echo "$info" | cut -d: -f3)
    ip=$(nmcli -t -f IP4.ADDRESS d show "$(nmcli -t -f DEVICE,TYPE d | grep wifi | cut -d: -f1)" 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
    echo "wifi|$ssid|$signal|$ip"
elif [ "$type" = "ethernet" ]; then
    ip=$(nmcli -t -f IP4.ADDRESS d show "$(nmcli -t -f DEVICE,TYPE d | grep ethernet | cut -d: -f1)" 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
    echo "ethernet||0|$ip"
else
    echo "disconnected||0|"
fi
