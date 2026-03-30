#!/usr/bin/env bash

set -u

RECORD_DIR="$HOME/Videos/gpu-screen-recorder"
CONTAINER="mkv"
PID_FILE="$HOME/.cache/gpu-screen-recorder-waybar.pid"
OUT_FILE="$HOME/.cache/gpu-screen-recorder-waybar.out"

get_pid() {
  [ -f "$PID_FILE" ] || return 1
  cat "$PID_FILE" 2>/dev/null
}

get_outfile() {
  [ -f "$OUT_FILE" ] || return 1
  cat "$OUT_FILE" 2>/dev/null
}

is_running() {
  local pid
  pid="$(get_pid)" || return 1
  [ -n "$pid" ] || return 1
  kill -0 "$pid" >/dev/null 2>&1
}

print_status() {
  if is_running; then
    printf '{"text":"󰻃","tooltip":"Recording... click to stop","class":"recording"}\n'
  else
    printf '{"text":"󰕧","tooltip":"Left: region | Right: portal | Mid: open folder","class":"idle"}\n'
  fi
}

stop_recording() {
  local pid
  local out
  pid="$(get_pid)" || return 0
  [ -n "$pid" ] || return 0
  out="$(get_outfile || true)"
  kill -INT "$pid" >/dev/null 2>&1 || true
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    kill -0 "$pid" >/dev/null 2>&1 || break
    sleep 0.1
  done
  rm -f "$PID_FILE"
  rm -f "$OUT_FILE"
  if [ -n "$out" ]; then
    notify-send -a "Waybar Recorder" "Recording stopped" "Saved to: $out"
  else
    notify-send -a "Waybar Recorder" "Recording stopped" "Saved to: $RECORD_DIR"
  fi
}

start_recorder() {
  local target
  target="$RECORD_DIR/record-$(date +%Y%m%d-%H%M%S).$CONTAINER"
  mkdir -p "$RECORD_DIR" "$HOME/.cache"
  nohup gpu-screen-recorder "$@" -c "$CONTAINER" -o "$target" >/dev/null 2>&1 &
  echo "$!" > "$PID_FILE"
  echo "$target" > "$OUT_FILE"
  notify-send -a "Waybar Recorder" "Recording started" "Output: $target"
}

start_region() {
  local region
  region="$(slurp -f '%wx%h+%x+%y')" || exit 0
  [ -n "$region" ] || exit 0
  start_recorder -w region -region "$region"
}

start_portal() {
  start_recorder -w portal
}

toggle_region() {
  if is_running; then
    stop_recording
  else
    start_region
  fi
}

toggle_portal() {
  if is_running; then
    stop_recording
  else
    start_portal
  fi
}

case "${1:-status}" in
  status)
    print_status
    ;;
  toggle-region)
    toggle_region
    ;;
  toggle-portal)
    toggle_portal
    ;;
  stop)
    stop_recording
    ;;
  *)
    exit 1
    ;;
esac
