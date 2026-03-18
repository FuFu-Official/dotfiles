#!/bin/bash
wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $1
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}')
notify-send -h string:x-canonical-private-synchronous:volume "volume: ${volume}%" -t 800
