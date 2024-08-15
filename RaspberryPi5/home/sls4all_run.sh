#!/bin/bash
export APPENV_NAME="Inova-RaspberryPi5"
export APPROOT_DIR="${HOME}/SLS4All"
export SPLASH_DIR="${HOME}"
CURRENT_DIR="${APPROOT_DIR}/Current"
CURRENT_SCRIPT="${CURRENT_DIR}/sls4all_run_Inova_RaspberryPI5.sh"

while :; do
    echo "Starting: $CURRENT_SCRIPT"
    chmod +x "$CURRENT_SCRIPT"
    $CURRENT_SCRIPT "$@"
    RES=$?
    echo "Exit $RES: $CURRENT_SCRIPT"
    if [ $RES -eq 5 ]; then
        echo "Will restart: $CURRENT_SCRIPT"
        continue
    fi
    break
done
