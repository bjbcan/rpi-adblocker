# 1. copy pi-gen/* in to the pi-gen build dir
# 2. remove EXPORT_IMAGE from stage4 and stage5
# 3. update cmdline.txt with the volume id when build is complete; mount, change, unmount.
#    via change to pi-gen/stage2/01-sys-tweaks/00-patches/07-resize-init.diff 
# 4. gzip and send to somewhere

echo "must run this from the building `pi-gen` root directory."
echo "please specify SOURCE env var as the directory *from* which to copy the modified/added pi-gen content"

read -p "Do you want to proceed? (yes/no) " yn

case $yn in 
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

echo "removing EXPORT_NOOBS"
rm -rf stage2/EXPORT_NOOBS
echo "copying contents from source to pi-gen build target directory"
cp -vR $SOURCE/* .

echo "done."

IMG_NAME=2022-11-24-bradblocker-lite;

# in guest VM
./mounthost.sh  # mount the host files in the guest/build OS
./copyfiles.sh # copy the build files from host to guest/build OS
sudo CONTINUE=1 ./build.sh; # continue from last build 
sudo CLEAN=1 ./build.sh; # rebuild last stage
sudo ./build.sh; # start from fresh
mv work/bradblocker/export-image/$IMG_NAME.img ../DesktopHost/rpi-adblocker/ ; 
mv deploy/image_$IMG_NAME.zip ../DesktopHost/rpi-adblocker/

# in host Mac
# gzip, send to macmini, copy to sd; [!] try this with 4k block size (faster?)
# 512b is 1506 kB/s
# 4k is 5277 kB/s
sudo diskutil unmount /dev/disk2s1; 
sudo dd if=$IMG_NAME.img of=/dev/disk2 bs=4k status=progress

# Run some tests in QEMU
# in host Mac
$QEMU_IMG_LOC=/Users/brad/Desktop/rpi_qemu/macos-qemu-rpi/native-emulation
$IMG_LOC=/Users/brad/Desktop/rpi-adblocker
cp $IMG_LOC/$IMG_NAME.img $QEMU_IMG_LOC
qemu-img resize -f raw $IMG_LOG/$IMG_NAME.img 4G
#set IMAGE_FILE in run.sh
sed -i.bak "s|readonly\ IMAGE=.*|readonly\ IMAGE\=\'$IMG_NAME\'|g" run.sh
./run.sh
