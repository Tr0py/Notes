# Emulating NVDIMM on Linux
# Followed the instructions on https://www.intel.com/content/www/us/en/developer/articles/training/how-to-emulate-persistent-memory-on-an-intel-architecture-server.html


# Uninstalling pre-build PMDK packages
# PMDK related packages
# libpmem1 librpmem1 libpmemblk1 libpmemlog1 libpmemobj1 libpmempool1 libvmem1 \
# libpmem-dev librpmem-dev libpmemblk-dev libpmemlog-dev libpmemobj-dev libpmempool-dev libpmempool-dev libvmem-dev \
# libpmem1-debug librpmem1-debug libpmemblk1-debug libpmemlog1-debug libpmemobj1-debug libpmempool1-debug
# use apt install / remove to manage them.

# Installing dependencies for PMDK
## It needs libndctl > v63 but ubuntu 18 only has 61 so we need to compile from source.
## Compiling NDCTL
### Installing dependencies for NDCTL
# ref: https://docs.pmem.io/ndctl-user-guide/installing-ndctl/installing-ndctl-from-source-on-linux
# note to add an 1 to libiniparser

# sudo apt install -y git gcc g++ autoconf automake asciidoc asciidoctor bash-completion \
#     xmlto libtool pkg-config libglib2.0-0 libglib2.0-dev libfabric1 libfabric-dev doxygen \
#     graphviz pandoc libncurses5 libkmod2 libkmod-dev libudev-dev uuid-dev libjson-c-dev \
#     libkeyutils-dev libiniparser1 libiniparser-dev bc meson

# Error: when running build, there is another error about json-c.
# I give up.  The official support for nvctl on ubuntu 18 is 61.2 maybe for a reason.
# I'll use a newer version ubuntu.
# ubuntu 20.04 works just fine with the instructions on website.

# But we can just install it from apt.
# https://docs.pmem.io/ndctl-user-guide/installing-ndctl/installing-ndctl-packages-on-linux
#sudo apt install ndctl daxctl
# Then install PMDK using above related packages.

# But it does not have libpmem2
# have to compile from source.
Building PMDK:

 followed the instructions on https://docs.pmem.io/persistent-memory/getting-started-guide/installing-pmdk/compiling-pmdk-from-source
 remember to install `libdaxctl`, `ndctl`, and `daxctl`.
# Compiled from source.


# use examples from pmdk source repo.
# use libpmem2 basic to write to file and use advance to reaad from file.
# finding mmap
# strace results for cmd `strace ./advanced /dev/dax0.0 2813 9530 &> strace.log`
 mmap(NULL, 1816784, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff5c0c94000
 mmap(0x7ff5c0c99000, 1728512, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7ff5c0c99000
 mmap(0x7ff5c0e3f000, 57344, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ab000) = 0x7ff5c0e3f000
 mmap(0x7ff5c0e4d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b8000) = 0x7ff5c0e4d000
 mmap(0x7ff5c0e4f000, 2256, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff5c0e4f000

# should be one of these.



# Verifing NVDIMM functionality
sudo fdisk -l /dev/pmem0
# Convert pmem to devdax
# https://github.com/qemu/qemu/blob/master/docs/nvdimm.txt
ndctl create-namespace -f -e namespace0.0 -m devdax

# Cannot create devdax????
➜  ~ sudo ndctl create-namespace -f -e namespace0.0 --mode=devdax --size 2G
libndctl: ndctl_dax_enable: dax0.0: failed to enable
  Error: namespace0.0: failed to enable

failed to reconfigure namespace: No such device or address
➜  ~ sudo ndctl create-namespace -f -e namespace0.0 --mode=fsdax --size 2G
{
  "dev":"namespace0.0",
  "mode":"fsdax",
  "map":"dev",
  "size":"3.94 GiB (4.23 GB)",
  "uuid":"3c8b586e-dcb9-4cf3-a3c0-ad176fbf4242",
  "sector_size":512,
  "align":2097152,
  "blockdev":"pmem0"
}

# could be this: https://lkml.org/lkml/2018/2/26/993
# But is aligned to 1G!!!! WTF?!
# TODO: try mem!mem  for host first and then guest

# FK. i think it's bc of the kernel config....
grep 'DAX' .config
CONFIG_NVDIMM_DAX=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
# CONFIG_DEV_DAX is not set
# CONFIG_FS_DAX is not set


grep 'PMEM' .config
# CONFIG_X86_PMEM_LEGACY is not set
# CONFIG_VIRTIO_PMEM is not set
CONFIG_BLK_DEV_PMEM=y
CONFIG_ARCH_HAS_PMEM_API=y
# remember to check the kernel config first....
# Set all of them to y or m!
# !!!!!!
# Some libraries tries to load the kernel modules so you might need to compile
# them as modules and install them to guest kernel.  See my notes about vm setup
# for how to do this in the "Installing kernel modules to guest VM" section.
# Eg. ndctl wants to find the kernel module anyway so you need to provide them
# ko.
# !!!!!!
# Now it works!!! damn.

# Test: use examples under pmdk/src/examples/libpmem2
# Write "hello, persistent memory" to pmem
./basic /dev/dax0.0
# Read out the content
./advanced /dev/dax0.0 0 100
68 65 6C 6C 6F 2C 20 70 65 72 73 69 73 74 65 6E
74 20 6D 65 6D 6F 72 79 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 %

# That is the string in hex ascii.

GJ!


# When configuring dax for memory mode: see the kmem module not found bug
# https://stevescargall.com/2019/07/09/how-to-extend-volatile-system-memory-ram-using-persistent-memory-on-linux/
sudo daxctl reconfigure-device dax0.0 --mode=system-ram
libkmod: ERROR ../libkmod/libkmod-module.c:838 kmod_module_insert_module: could not find module by name='kmem'
libdaxctl: daxctl_insert_kmod_for_mode: dax0.0: insert failure: -2
error reconfiguring devices: No such file or directory
reconfigured 0 devices

lsmod
# lsmod shows nothing, my kernel might be a monolithic kernel...
# see https://archive.download.redhat.com/pub/redhat/linux/4.2/en/os/alpha/doc/rhmanual/doc037.html

Legend: [*] built-in  [ ] excluded  <M> module  < > module capable

# Error: Driver 'kmem' is already registered, aborting.
# fk me.

# I manually M ed KMEM module and copy pasted the /lib/modules/xxx/
# to guest fs and then it works.
sudo daxctl reconfigure-device dax0.0 --mode=system-ram
[sudo] password for z:
libdaxctl: memblock_in_dev: dax0.0: memory0: Unable to determine phys_index: Success
libdaxctl: memblock_in_dev: dax0.0: memory0: Unable to determine phys_index: Success
dax0.0:
  WARNING: detected a race while onlining memory
  Some memory may not be in the expected zone. It is
  recommended to disable any other onlining mechanisms,
  and retry. If onlining is to be left to other agents,
  use the --no-online option to suppress this warning
dax0.0: all memory sections (31) already online
libdaxctl: memblock_in_dev: dax0.0: memory0: Unable to determine phys_index: Success
[
  {
    "chardev":"dax0.0",
    "size":4292870144,
    "target_node":0,
    "mode":"system-ram",
    "movable":false
  }
]
reconfigured 1 device
