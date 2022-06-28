
# Uninstalling pre-build PMDK packages
# PMDK related packages
libpmem1 librpmem1 libpmemblk1 libpmemlog1 libpmemobj1 libpmempool1 libvmem1 \
libpmem-dev librpmem-dev libpmemblk-dev libpmemlog-dev libpmemobj-dev libpmempool-dev libpmempool-dev libvmem-dev \
libpmem1-debug librpmem1-debug libpmemblk1-debug libpmemlog1-debug libpmemobj1-debug libpmempool1-debug
# use apt install / remove to manage them.

# Installing dependencies for PMDK
## It needs libndctl > v63 but ubuntu 18 only has 61 so we need to compile from source.
## Compiling NDCTL
### Installing dependencies for NDCTL
# ref: https://docs.pmem.io/ndctl-user-guide/installing-ndctl/installing-ndctl-from-source-on-linux
# note to add an 1 to libiniparser

sudo apt install -y git gcc g++ autoconf automake asciidoc asciidoctor bash-completion \
    xmlto libtool pkg-config libglib2.0-0 libglib2.0-dev libfabric1 libfabric-dev doxygen \
    graphviz pandoc libncurses5 libkmod2 libkmod-dev libudev-dev uuid-dev libjson-c-dev \
    libkeyutils-dev libiniparser1 libiniparser-dev bc meson

# Error: when running build, there is another error about json-c.
# I give up.  The official support for nvctl on ubuntu 18 is 61.2 maybe for a reason.
# I'll use a newer version ubuntu.
# ubuntu 20.04 works just fine with the instructions on website.

# But we can just install it from apt.
# https://docs.pmem.io/ndctl-user-guide/installing-ndctl/installing-ndctl-packages-on-linux
# Then install PMDK using above related packages.

# But it does not have libpmem2
