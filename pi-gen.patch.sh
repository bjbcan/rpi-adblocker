# 1. copy pi-gen/* in to the pi-gen build dir
# 2. remove EXPORT_IMAGE from stage4 and stage5
# 3. update cmdline.txt with the volume id when build is complete; mount, change, unmount.
#    via change to pi-gen/stage2/01-sys-tweaks/00-patches/07-resize-init.diff 
# 4. gzip and send to somewhere

echo "must run this fro the `pi-gen` root directory.."
sleep 10s

# gzip, send to macmini, copy to sd; [!] try this with 4k block size (faster?)
# 512b is 1506 kB/s
# 4k is 5277 kB/s
IMG=2022-11-24-pigennode2-lite.img; ssh macmini "gzip -c ~/pi-gen/work/pigennode2/export-image/$IMG > ~/$IMG.gz"; scp macmini:~/$IMG.gz .; sudo diskutil unmount /dev/disk2s1; sudo dd if=2022-11-24-pigennode2-lite.img of=/dev/disk2 bs=4k status=progress