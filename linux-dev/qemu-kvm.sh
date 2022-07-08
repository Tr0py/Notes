

# command to run qemu
qemu-system-x86_64 -kernel bzImage \
                       -append "root=/dev/sda rw console=ttyS0" \
                       -hda ~/qemu-image.img \
                       --enable-kvm \
                       --nographic \
                       -m 8G,slots=8,maxmem=128G \
                       -smp 2 \
                       -machine pc,accel=kvm,nvdimm \
                       -object memory-backend-file,id=mem1,share=on,mem-path=/home/ziyi/fnvdimm,size=4G \
                       -device nvdimm,id=nvdimm1,memdev=mem1 \
                       -net nic -net user,hostfwd=tcp::2222-:22




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
chmod a+x /rc.local

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


