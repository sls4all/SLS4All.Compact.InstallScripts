#!/bin/bash
if [ "$1" != "reboot" ]; then
  # send custom poweroff klipper command to all potential Klipper MCUs
  while :; do
    for device in /dev/serial/by-id/usb-*; do
      echo "SYSTEM_POWEROFF" > $device
    done
    sleep 1
  done
fi