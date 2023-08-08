#!/bin/bash
echo "run from pi-gen build directory(/home/brad/pi-gen)"
echo "copying host pi-gen code to guest pi-gen build dir ..."
cp -vR ../DesktopHost/rpi-adblocker/pi-gen/* .
echo "---\n done\n"
