#!/bin/sh
#
qemu=qemu-system-x86_64
initrd=initrd.img

if [ -n "$1" ]; then
    kernel_ver=$1
else
    kernel_ver=$(uname-r)
fi

vmlinuz=/boot/vmlinuz-$kernel_ver


$qemu -m 8000 \
    -kernel $vmlinuz \
    -initrd $initrd \
    -enable-kvm \
    -net nic \
    -net user \
    -drive file=../installer/disk.img,id=disk,if=none,format=raw \
    -device ahci,id=ahci \
    -device ide-hd,drive=disk,bus=ahci.0 \
    -append "console=ttyS0,115200n8 root=/dev/ram rd.shell=1" \
    -serial telnet:localhost:5555,server,nowait \
    -nographic

