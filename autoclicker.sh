#!/usr/bin/env bash
# Toggle autoclicker on/off. Bind this script to a global shortcut.
#
# Uses ydotool (works on Wayland via uinput, unlike xdotool which
# requires X11) plus a flock-based lock and a stop-flag file, so
# there's no PID tracking and nothing to race between hotkey presses.
#
# Requires: ydotool + ydotoold running (systemctl --user enable --now ydotool.service)
# Your user must be in the `input` group.

LOCKFILE="/tmp/.autoclicker.lock"
STOPFLAG="/tmp/.autoclicker.stop"
INTERVAL=0.06   # ~16 clicks/sec. Lower = faster, higher = slower.
BUTTON=0xC0     # left click

exec 9>"$LOCKFILE"

if flock -n 9; then
    # Got the lock -> nothing is currently running -> start clicking
    rm -f "$STOPFLAG"
    notify-send "Autoclicker" "Started" 2>/dev/null
    while [[ ! -f "$STOPFLAG" ]]; do
        ydotool click $BUTTON
        sleep $INTERVAL
    done
    rm -f "$STOPFLAG"
    notify-send "Autoclicker" "Stopped" 2>/dev/null
else
    # Lock is already held -> a loop is running -> tell it to stop
    touch "$STOPFLAG"
fi
