# Base modules
BASE_MODULES="ahci sd_mod crc32c ext4"

# CRYPT
CRYPT_DEV=

# LVM
ROOTFS_DEV=/dev/mapper/system_vg-root

HOOKS="base_modules udev lvm rootfs"
