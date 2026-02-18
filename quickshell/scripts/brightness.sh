#!/bin/bash
cur=$(cat /sys/class/backlight/*/brightness 2>/dev/null | head -1)
max=$(cat /sys/class/backlight/*/max_brightness 2>/dev/null | head -1)
echo "${cur:-0}|${max:-100}"
