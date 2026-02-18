#!/bin/bash
powered=$(bluetoothctl show 2>/dev/null | grep -c "Powered: yes")
connected_dev=$(bluetoothctl info 2>/dev/null | grep "Name:" | head -1 | sed 's/.*Name: //')
if [ "$powered" = "1" ]; then
    if [ -n "$connected_dev" ]; then
        echo "on|connected|$connected_dev"
    else
        echo "on|disconnected|"
    fi
else
    echo "off|disconnected|"
fi
