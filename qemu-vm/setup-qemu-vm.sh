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
