# 1. copy pi-gen/* in to the pi-gen build dir
# 2. remove EXPORT_IMAGE from stage4 and stage5
# 3. update cmdline.txt with the volume id when build is complete; mount, change, unmount.
#    via change to pi-gen/stage2/01-sys-tweaks/00-patches/07-resize-init.diff 
# 4. gzip and send to somewhere
