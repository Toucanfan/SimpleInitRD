# Base modules
#BASE_MODULES="ahci sd_mod nvme xhci_pci usb_storage ccm xts cryptd aesni_intel sha512_generic sha256_ssse3 crc32c ext4"
BASE_MODULES="ahci sd_mod nvme xhci_pci usb_storage ext4"

# CRYPTSETUP
CRYPT_DEV=/dev/sda3
CRYPT_NAME=crypt_root

# LVM
ROOTFS_DEV=/dev/mapper/system_vg-root

#HOOKS="base_modules udev lvm rootfs"
HOOKS="base_modules udev cryptsetup lvm rootfs"
