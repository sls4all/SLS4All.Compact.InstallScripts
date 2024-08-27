# SLS4All Compact installation scripts

## Introduction
This software is part of SLS4All project. For more information please visit https://sls4all.com.

## Copying
*SLS4All Compact* source code and binaries are available under the terms of the 
License Agreement as described in the LICENSE.txt file located 
in the root directory of the repository or visit 
https://sls4all.com/terms-of-use/.

>##### In very short non-binding terms:
>You can use, copy, modify, and convey the software for **non-commercial** purposes **only**.
You can share modified versions of the software as long as you retain original notices, license 
and provide access to the modified source.
>
>We are not responsible for any damages, injuries, etc. caused in connection with the software. By exercising any right granted under the License, you irrevocably accept all its terms and conditions.

## What these scripts do

*SLS4All Compact* software is intended to be run on embedded computer sitting inside the Inova printer. We are using **Raspberry PI 5 4GB** for our kits. This software displays a local user interface on a printer touchscreen display while it also allows complete remote control of the printer via web browser (just enter the printer IP address to the browser on your computer). The local UI (on display) and remote UI (in the browser) are identical in features and looks.

These scripts are a way to automatically install all dependencies and the software binaries on your embedded computer.

## Sources for the software

Sources for the *SLS4All Compact* software are on [GitHub](https://github.com/sls4all/SLS4All.Compact) and you can also compile and install them manually yourself if you want.

## How to use the scripts in this repository

Currently we have prepared installation script for **Raspberry PI 5**. It is strongly recommended to use **4GB RAM** variant (or more, and **64-bit OS**). On anything less the software will probably not work correctly. We also suggest to use a reasonably fast SD card (~100MB/sec for read, and >60MB/sec for write) with capacity **>=16GB** (32GB preferred).

If you have a clean SD card, the recommended installation procedure is as follows:

- Download and run the [Raspberry PI Imager](https://www.raspberrypi.com/software/)
  - Choose your device: **Raspberry Pi 5**
  - Choose: **Raspberry PI OS (64-bit)**
  - In the wizard edit and apply following customisations:
    - In the GENERAL tab:
      - Set hostname. E.g.: **inova**
      - Select "Set username and password". 
      - Enter username (e.g. **printer**) and some reasonably secure password for remote access to the Raspberry PI (used for SSH and VNC)
    - In the Services tab:
      - Enable SSH and select either "Password authentication" which is the simplest or "Allow public-key authentication only" if you have used that before.
- Insert the newly created SD card to Raspberry PI and power it up
- Freely register or login to [SLS4All website](https://sls4all.com/my-account/member-id/) and copy or generate Member Id from your profile
  - Please note that we use the Member Ids to track how many SLS4All printers are in the world. It is the only thing we ask of you for using our software. No other data is being collected.
- Either connect a display and keyboard or access the device via SSH and network
- Connect the Raspberry PI to internet using Ethernet or Wi-Fi
- The following commands will install all necessary system packages, latest stable version of SLS4All Compact Printer Application and do the neccessary configuration
- Enter following in a Raspnerry PI Terminal to start the installation. Enter Member Id from the step above when requested.

```
git clone https://github.com/sls4all/SLS4All.Compact.InstallScripts.git
cd SLS4All.Compact.InstallScripts/RaspberryPi5
./install_sls4all.sh
```

- Installation procedure should complete with suggestion to reboot the device.
- Do not reboot yet, if you have not installed the firmware as described below.

## Install the Klipper Firmware

Inova MK1 printer has two additional MCU boards to function. The **BIGTREETECH SKR 1.4 Turbo** and **SLS4All ZERO1** with Arduino Nano. These boards need to have an initial version of our modified Klipper firmware installed. Please use following steps to install the firmware. After the initial install, the SLS4All.Compact software updates will automatically upgrade the firmware also, but the initial manual install is neccessary.

### BIGTREETECH SKR 1.4 Turbo

- Pick any microSD card. Even very slow or very small <32**MB** (not GB!) cards will work. You can also use more common large and fast cards, but it is not required. 
- Format it with FAT32 filesystem using any OS wizard or tool you prefer
- Copy the file ~/SLS4All/Current/Firmware/lpc1769.bin from the printer to the SD card
- Rename the file on the SD card as `firmware.bin`
- Safely eject the SD card from your computer
- Place the SD card to *SKR 1.4 Turbo* board
- Press the *Reset* button on the *SKR 1.4 Turbo* board
- Please note that the SD card is not strictly neccessary to be left inserted in the board from this point, since the contents have been transferred to internal flash memory on the SKR. We however strongly suggest to leave the SD card inserted in the board (forever), so the SLS4All.Compact can internally use it to upgrade the firmware if required. 
- You are done with this board!

### SLS4All ZERO1

- Connect the SLS4All ZERO1 board with Arduino Nano to the printer using USB cable (if you have not yet done that already)
- Determine the Linux USB device the ZERO1 board has in the OS. This is typically something like
  - /dev/serial/by-id/usb-FTDI_FT232R_USB_UART_\*-if\*-port\*
  - or
  - /dev/serial/by-id/usb-\*_USB\*Serial-if\*-port\*
- Enter following command to terminal. Replace {DeviceEndpoint} with the full path of the device you found out in the step before 
- `avrdude -v -p atmega328p -c arduino -P {DeviceEndpoint} -b 57600 -D -U flash:w:~/SLS4All/Current/Firmware/atmega328p.elf.hex:i`
- If the command fails to connect to the Arduino Nano, you can also try different baud (serial speed). Replace `-b 57600` with `-b 115200` and try again.
- You are done with this board!

## Complete the install
- Reboot the device and the SLS4All Compact software should **start automatically**
```
sudo reboot
```
