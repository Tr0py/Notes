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

# Setup NUMA node
 qemu-system-x86_64 -kernel bzImage \
                        -append "root=/dev/sda rw console=ttyS0" \
                        -hda ./qemu-image.img \
                        --enable-kvm \
                        --nographic \
                        -m 8G,slots=8,maxmem=128G \
                        -smp cpus=2 \
                        -numa node,cpus=0,nodeid=0,mem=4G \
                        -numa node,cpus=1,nodeid=1,mem=4G \
                        -machine pc,accel=kvm,nvdimm \
                        -object memory-backend-file,id=mem1,share=on,mem-path=./fnvdimm,size=4G,align=1G,pmem=on \
                        -device nvdimm,id=nvdimm1,memdev=mem1 \
                        -net nic -net user,hostfwd=tcp::2222-:22
# Check NUMA memory status
numastat -m
numactl -H

# Network setup

http://www.linux-kvm.org/page/Networking

# Install virt-manager !!!!!!!!! and related kvm dependencies first!
# https://phoenixnap.com/kb/ubuntu-install-kvm
apt install virt-manager qemu-kvm

# bring up network interface
ip link set xxxx up
# Run dhclient in guest to get the ip addr!!!!!
dhclient
# https://unix.stackexchange.com/questions/523922/no-ip-address-assigned-to-kvm-guest-after-its-cloned-from-another-guest

# setup env using AutoECS
# remember to configure sources.list first!!!!!
sh -c "$(wget https://raw.githubusercontent.com/Tr0py/AutoECS/master/AutoECS.sh -O -)"

# Automatically run dhclient on booting
# add dhclient to rc.local
# ref: https://www.simplified.guide/linux/automatically-run-program-on-startup
vim /etc/rc.local

```
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
dhclient
# test: uncomment this and you should see there's one more "1" on
# /root/hello everytime you boot
# echo "1" >> /root/hello
exit 0
```

# remember to give it executable privilege!!!
chmod a+x /etc/rc.local

# Finally works!

# Use ssh to connect to guest
ssh -p 2222 localhost -l xxx
# but lsmem shows "lsmem: This system does not support memory blocks"
# it should be the kernel's problem: if I use the non-kvm compiled kernel, it just works.
# and using kvm acc still boosts the boot speed with normal kernel image
# so let's just use normal kernel now
# but there's no libvirt. fuck.

# next is about setting up vnvdimm emulation on qemu/kvm.

# make menuconfig to enable a bunch of support for guest, especially all the NVDIMM
# support, so with the qemu-system command, there shows /dev/pmem0.!
# also, lsmem now works!
# Great!


# Appendix
# If you want to change your vm's hostname, use this inside your vm:
sudo hostnamectl set-hostname <new-hostname>
