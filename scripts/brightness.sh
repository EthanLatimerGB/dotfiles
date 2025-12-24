#!/bin/bash

#
# This is a program that handles brightness for PC-Laptops, depending on your setup.
#

# constants
CACHE_FILE="/tmp/brightness_cache_el"
LOCKFILE="/tmp/brightness_el.lock"
MAX_BRIGHTNESS="100"

function main {
	if [[ $# != 1 ]]; then
		echo_err "Unable to change brightness - args count incorrect"
		return 1
	fi
	increment=$1

	# Acquire Lock
	exec 200>"$LOCKFILE"
	flock -n 200 || exit 0   # exit immediately if locked

	if ! check_utils_exist; then
		return 1;	
	fi

	touch $CACHE_FILE
	
	
	monitor_handler $increment || {
		echo_err "No Monitor Detected" "Double check with ddutils or brightnessctl to see if you can control your monitor manually."
		exit 1
	}

	echo "Complete"
}

# functions
function echo_err {
	echo "FAILURE: $1 $2"
	notify-send -a "Brightness Control" -u critical -t 3000 "$1" "$2"
}

function echo_noti {
	echo "INFO: $1 $2"
	notify-send -a "Brightness Control" -u normal -t 3000 "$1" "$2"
}

function echo_progress {
	notify-send "Brightness" \
		-h int:value:$1 \
		-h int:max:100 \
		-h string:transient:1
}

function cache_get {
	local key=$1
	if [[ -f "$CACHE_FILE" ]]; then
	    grep -E "^$key=" "$CACHE_FILE" | tail -n1 | cut -d= -f2-
	fi
}

function cache_set {
	local key=$1
	local value=$2

	# Remove old entry if it exists
	grep -v -E "^$key=" "$CACHE_FILE" 2>/dev/null > "${CACHE_FILE}.tmp" || true
	echo "$key=$value" >> "${CACHE_FILE}.tmp"
	mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
}

## For simplicity - both utils must be installed even if useless
function check_utils_exist {
	if ! command -v brightnessctl >/dev/null 2>&1
	then
		echo_err "Cannot find brightnessctl" "Install with your package manager."
		return 1
	fi

	if ! command -v ddcutil >/dev/null 2>&1
	then
		echo_err "Cannot find ddcutil" "Install with your package manager."
		return 1
	fi

	return 0
}

function modify_brightness {
	local current=$1
	local delta=$2

	# Add delta
	local result=$((current + delta))

	# Clamp to 0..max
	if (( result < 0 )); then
		result=0
	elif (( result > MAX_BRIGHTNESS )); then
		result=$MAX_BRIGHTNESS
	fi

	echo "$result"
}

function monitor_handler {
	if brightnessctl | grep -q backlight; then
		echo "brightness"
		return 0
	elif command -v ddcutil >/dev/null 2>&1; then
		echo "ddcutil"

		brightness=$(cache_get "g_brightness")
		if [[ -z "$brightness" ]]; then
			brightness="$(ddcutil getvcp 10 | awk '/current value =[[:space:]]+[0-9][0-9]/ { gsub(/.*current value *= */,""); gsub(/,.*/,""); print }')"
			cache_set "g_brightness" "$brightness"
		fi

		if (( $1 == 1 )); then
			new_brightness=$(modify_brightness "$brightness" 5)
		else
			new_brightness=$(modify_brightness "$brightness" -5)
		fi

		cache_set "g_brightness" "$new_brightness"

		ddcutil setvcp 10 "$new_brightness" 
		echo_progress $new_brightness

		return 0
	else
		echo "none"
		return 1
	fi
}

main "$@"

