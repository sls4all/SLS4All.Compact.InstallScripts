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

*SLS4All Compact* software is intended to be run on embedded computer sitting inside a Inova printer. We are using **Raspberry PI 5 4GB** for our kits. This software displays a local user interface on a printer touchscreen display while it also allows complete remote control of the printer via web browser (just enter the printer IP address to the browser on your computer). The local UI (on display) and remote UI (in the browser) are identical in features and looks.

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
- Register or login to [SLS4All website](https://sls4all.com/my-account/member-id/) and copy or generate Member Id from your profile
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
- Reboot the device and the SLS4All Compact software should **start automatically**
```
sudo reboot
```
