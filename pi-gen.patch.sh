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



# re-Building images
docker builder prune
docker rmi pi-gen
cp -vR ../rpi-adblocker/pi-gen/ .

# in host Mac
# gzip, send to macmini, copy to sd; [!] try this with 4k block size (faster?)
# 512b is 1506 kB/s
# 4k is 5277 kB/s
sudo diskutil unmount /dev/disk4s1; 
sudo dd if=$IMG_NAME.img of=/dev/disk4 bs=2m status=progress

# Run some tests in QEMU
# in host Mac
$QEMU_IMG_LOC=/Users/brad/Desktop/rpi_qemu/macos-qemu-rpi/native-emulation
$IMG_LOC=/Users/brad/Desktop/rpi-adblocker
cp $IMG_LOC/$IMG_NAME.img $QEMU_IMG_LOC
qemu-img resize -f raw $IMG_LOG/$IMG_NAME.img 4G
#set IMAGE_FILE in run.sh
sed -i.bak "s|readonly\ IMAGE=.*|readonly\ IMAGE\=\'$IMG_NAME\'|g" run.sh
./run.sh

# from pi-run dir
IMAGE_FILE=../pi-gen/deploy/2025-01-05-bradblocker-lite-qemu.img
PTB_FILE=bcm2710-rpi-3-b-plus.dtb
KERNEL_FILE=kernel8.img
qemu-img resize -f raw "$IMAGE_FILE" 4G
sudo qemu-system-aarch64 \
	-m 1024 -M raspi3b -kernel kernel8.img \
	-dtb bcm2710-rpi-3-b-plus.dtb -sd ${IMAGE_FILE} \
	-append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" \
	-nographic -device usb-net,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::5555-:22,hostfwd=tcp::8888-:80
