# If you have an out of tree repo that contains your hacks but want to merge
# your hacks into the mainline kernel, you could use patch.
# For example, I downloaded the .zip linux kernel and started a new tree with my
# modifications.  Now I want to merge it with latest kernel, I can not simply
# rebase because I am out of the kernel tree.
# Fortunately, I can use patch to do it and preserving the commits.
$ git format-patch 27ec4a593ef5b5f1600b91237ee..00b91237ee00b91237ee
0001-Config-file-for-kvm-guest-with-pmem-support.patch
0002-Add-debug-macro-PDBG.patch
0003-Debug-mmap-print-file-name.patch
...

# This will generate the patches.
# Use git am *.patch to apply, in the up-to-date kernel source tree.

$ git am ../linux-5.4.204/*.patch
Applying: Config file for kvm guest with pmem support.
Applying: Add debug macro PDBG.
Applying: Debug: mmap print file name.
Applying: Fix typo
...


# Done!
