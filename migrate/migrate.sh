# Migrating from a disk to another.

# Need to copy the root fs to another disk.
# Things to do: the EFI partition and the root FS.

# EFI partition is used fro UEFI boot.
# Root FS: use rsync or dd.
# See https://superuser.com/questions/307541/copy-entire-file-system-hierarchy-from-one-drive-to-another

# Use fdisk to partition the new disk
# Use mkfs -t ext4 to create a filesystem

mount /dev/sda1 ./mnt1
mount /dev/nvme0n1p2 /mnt2

# Use rsync to copy the filesystem
rsync -axHAWXS --numeric-ids --info=progress2 ./mnt1 ./mnt2
# understanding the meaning of the rsync output: https://unix.stackexchange.com/a/261139/462432


# After moving to a new disk, the uuid still stays the same, resulting in booting confusion
# !!!Remember to check grub.cfg in case the UUID is not changed.
lsblk -f  # to check the uuid of disks

# !!!Also, you need to update the fs uuid in the /boot/efi
vim /boot/efi/ubuntu/grub.cfg
# modify the uuid to the new uuid

# Enable linux to print boot time messages
# In grub.cfg, # find the line starting with GRUB_CMDLINE_LINUX_DEFAULT
# and remove the parameters quiet and splash.


