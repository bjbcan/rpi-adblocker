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
scp -r /Users/brad/Desktop/rpi-adblocker/pi-gen/. brad@macmini:~/pi-gen/


# gzip, send to macmini, copy to sd; [!] try this with 4k block size (faster?)
# 512b is 1506 kB/s
# 4k is 5277 kB/s
IMG=2022-11-24-pigennode2-lite.img; 
ssh macmini "gzip -c ~/pi-gen/work/pigennode2/export-image/$IMG > ~/$IMG.gz"; 
scp macmini:~/$IMG.gz .; 
sudo diskutil unmount /dev/disk2s1; 
IMG=2023-08-08-bradblocker-lite.img
sudo dd if=$IMG of=/dev/disk2 bs=4k status=progress


# in guest VM
./mounthost.sh
./copyfiles.sh
sudo su
IMG_FILE=2023-08-09-bradblocker-lite
CONTINUE=1 ./build.sh; mv work/export-image/$IMG_FILE.img ../DesktopHost/rpi-adblocker/ ; mv deploy/image_$IMG_FILE.zip ../DesktopHost/rpi-adblocker/

# in mac host
# from /Users/brad/Desktop/rpi_qemu/macos-qemu-rpi/native-emulation
IMG_FILE=2023-08-09-bradblocker-lite
cp  /Users/brad/Desktop/rpi-adblocker/$IMG_FILE.img ../../.
qemu-img resize -f raw "../../$IMG_FILE.img" 4G
#set IMAGE_FILE in run.sh
sed -i.bak "s|readonly\ IMAGE=.*|readonly\ IMAGE\=\'$IMG_FILE\'|g" run.sh
./run.sh
