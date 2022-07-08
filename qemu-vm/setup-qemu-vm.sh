# Setting up a VM through qemu-system
# Ref: https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/


# Adding a rootfs
IMG=qemu-image.img
DIR=mount-point.dir
qemu-img create $IMG 100g
# Format File System to ext4, instead of ext2 in the old tutorial
mkfs.ext4 $IMG
mkdir $DIR
sudo mount -o loop $IMG $DIR
# Installing Ubuntu to a File System using command line
# you can install the ubuntu version you want by looking up their names
# here: https://wiki.ubuntu.com/Releases
# In this example, focal is Ubuntu 20.04
sudo debootstrap --arch amd64 focal $DIR http://archive.ubuntu.com/ubuntu
sudo umount $DIR
rmdir $DIR
