# Set up aarch64 VM on x86_64 host

# 1. Compile Linux kernel
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
# Replace all "=m" with "=y" to build a kernel that does not need kernel modules.
# In vim,
:%s/=m/=y/g

# make menuconfig to do a auto-check.
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
# make sure there's no kernel modules
grep "=m" ./.config
# should output nothing

# compile the kernel
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)


# 2. Use qemu-system-aarch64 to launch the kernel
qemu-system-aarch64     -kernel <path_to_Image.bz> \
                        -nographic \
                        -cpu max \
                        -M virt
