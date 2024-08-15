#!/bin/bash
cd "$(dirname "$0")"
#set -x # echo on

echo 
echo "*********************************************************"
echo "*** This script will install SLS4All Compact software ***"
echo "*********************************************************"

sudo_grep_tee()
{
  FILENAME=$1
  TEXT=$2
  sudo cat "$FILENAME" | grep "$TEXT"
  if [ $? -ne 0 ]; then
    echo "$TEXT" | sudo tee -a "$FILENAME"
  fi
}

if [ "$(id -u)" -eq 0 ]; then
  echo "This script must NOT be run as root, it will request root access as needed" >&2
  exit 1
fi

UPDATE_SERVER="https://compact.sls4all.com"
CHANNEL="stable"
MEMBER_ID=""

while getopts "m:c:s:" flag
do
    case "${flag}" in
        s) UPDATE_SERVER="$OPTARG";;
        c) CHANNEL="stable";;
        m) MEMBER_ID="$OPTARG";;
        [?]) print >&2 "Usage: $0 [-s]"
             exit 1;;
    esac
done

if [[ $UPDATE_SERVER != */ ]]; then
    UPDATE_SERVER="$UPDATE_SERVER/"
fi

ARCH=$(uname -m)
case $ARCH in
    x64)
        ARCH="x64"
        ;;
    x86_64)
        ARCH="x64"
        ;;
    arm)
        ARCH="arm"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "*** Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

if [ -z "$MEMBER_ID" ]; then
    echo
    echo "*** Please provide a Member Id. It can be freely obtained by registering at https://sls4all.com. We use the Member Ids to track how many SLS4All printers are in the world. It is the only thing we ask of you for using our software. No other data is being collected."
    echo
    read -p "Enter Member Id: " MEMBER_ID
    if [ -z "$MEMBER_ID" ]; then
        exit 1
    fi
fi

echo 
echo "*******************************************"
echo "*** Installing SLS4All Compact software ***"
echo "*******************************************"

# install dependencies
sudo apt-get update
if [ $? -ne 0 ]; then
    echo "*** Failed to update package lists, are you connected to the internet? You may try running this script again." >&2
    exit 1
fi
sudo apt-get install -y xinput stm32flash avrdude libffi-dev build-essential libncurses-dev libusb-dev libusb-1.0 pqiv wmctrl xdotool chromium socat wget curl unzip
if [ $? -ne 0 ]; then
    echo "*** Failed to install the required packages, are you connected to the internet? You may try running this script again." >&2
    exit 1
fi

# disable services incompatible with serial devices
sudo systemctl mask brltty.service
sudo systemctl mask brltty-udev.service

# setup allowed priorities
sudo_grep_tee /etc/security/limits.conf "$USER    hard rtprio   99"
sudo_grep_tee /etc/security/limits.conf "$USER    hard rtprio   99"
sudo_grep_tee /etc/security/limits.conf "$USER    soft rtprio   99"
sudo_grep_tee /etc/security/limits.conf "$USER    hard nice     -20"
sudo_grep_tee /etc/security/limits.conf "$USER    soft nice     -20"

# copy scripts and files
sudo cp -rf usr/. /usr
cp -rf home/. /home/$USER
sudo chmod +x /usr/lib/systemd/system-shutdown/serial-power-off.sh
sudo chmod +x /home/$USER/sls4all_run.sh

# setup theme
sudo cp -f /etc/plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf.old
sudo rm -f /etc/plymouth/plymouthd.conf
echo "[Daemon]" | sudo tee -a /etc/plymouth/plymouthd.conf
echo "Theme=sls4all" | sudo tee -a /etc/plymouth/plymouthd.conf
sudo update-initramfs -u

# download SLS4All.Compact.PrinterApp
UPDATE_NAME=$(curl -s --fail "${UPDATE_SERVER}ApplicationUpdate/name/latest/$CHANNEL/linux/$ARCH?memberId=$MEMBER_ID")
if [ $? -ne 0 ]; then
  echo "*** Update server is down or the specified Member Id is not valid." >&2
  exit 1
fi
UPDATE_INFO=$(curl -s --fail "${UPDATE_SERVER}ApplicationUpdate/list/$UPDATE_NAME?memberId=$MEMBER_ID")
if [ $? -ne 0 ]; then
  echo "*** Update server is down or the specified Member Id is not valid." >&2
  exit 1
fi

echo
echo "*** Downloading printer application $UPDATE_NAME"
echo
rm -rf "$HOME/SLS4All/Current"
mkdir -p "$HOME/SLS4All/Current"
wget -O "$HOME/SLS4All/Current/_app.zip" "${UPDATE_SERVER}ApplicationUpdate/download/$UPDATE_NAME?memberId=$MEMBER_ID"
if [ $? -ne 0 ]; then
  echo "*** Failed to download the printer application." >&2
  exit 1
fi
( 
    cd "$HOME/SLS4All/Current/"
    unzip _app.zip
    rm -f _app.zip
    echo "$UPDATE_INFO" > "appinfo.json"
)

echo
echo "*** Waiting for all files to be written to storage"
echo
sudo sync
sleep 1
sudo sync

echo 
echo "*****************************************"
echo "*** DONE installing SLS4All software! ***"
echo "***                                   ***"
echo "*** You should reboot the RPi now.    ***"
echo "*** Use: sudo reboot                  ***"
echo "*****************************************"





