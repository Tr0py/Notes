
# Uninstalling pre-build PMDK packages
# PMDK related packages
libpmem1 librpmem1 libpmemblk1 libpmemlog1 libpmemobj1 libpmempool1 libvmem1 \
libpmem-dev librpmem-dev libpmemblk-dev libpmemlog-dev libpmemobj-dev libpmempool-dev libpmempool-dev libvmem-dev \
libpmem1-debug librpmem1-debug libpmemblk1-debug libpmemlog1-debug libpmemobj1-debug libpmempool1-debug
# use apt install / remove to manage them.

# Installing dependencies for PMDK
# It needs libndctl > v63 but ubuntu 18 only has 61 so we need to compile from source.
sudo apt install \
    autoconf pkg-config


