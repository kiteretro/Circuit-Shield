#!/bin/bash

# 
# This file originates from Kite's Circuit Sword control board project.
# Author: Kite (Giles Burgess)
# 
# THIS HEADER MUST REMAIN WITH THIS FILE AT ALL TIMES
#
# This firmware is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This firmware is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this repo. If not, see <http://www.gnu.org/licenses/>.
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root (sudo)"
  exit 1
fi

# Clear a bit of the screen
echo; echo; echo; echo; echo; echo

# Define some vars
LOGCOLLECTPATH="/boot/kite-logcollect"
COMPRESSEDNAME="kite-logcollect.tar.gz"
COMPRESSEDPATH="/boot/${COMPRESSEDNAME}"

# Create the log dir
mkdir -p ${LOGCOLLECTPATH}

# Clear out any existing logs
rm -f ${COMPRESSEDPATH}
rm -rf "${LOGCOLLECTPATH}/*"

# Collect files
cp /var/log/messages "${LOGCOLLECTPATH}/messages.txt"
cp /var/log/syslog "${LOGCOLLECTPATH}/syslog.txt"

# Run some commands
iwconfig > "${LOGCOLLECTPATH}/iwconfig.txt" 2>&1
rfkill list all > "${LOGCOLLECTPATH}/rfkill.txt" 2>&1
git -C /home/pi/Circuit-Shield/ rev-parse HEAD > "${LOGCOLLECTPATH}/cs-git.txt" 2>&1
lsusb > "${LOGCOLLECTPATH}/lsusb.txt" 2>&1

# Compress the logs
tar -zcf ${COMPRESSEDPATH} ${LOGCOLLECTPATH}

# Log the completion
echo "#########################"
echo "LOG COLLECTION COMPLETE"
echo
echo "INSERT INTO PC AND GRAB"
echo "THE FILE:"
echo
echo "  ${COMPRESSEDNAME}"
echo
echo "SAFE TO POWER OFF"
echo "#########################"
echo "(press enter for console)"

read