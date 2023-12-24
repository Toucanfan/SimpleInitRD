#!/bin/sh
#
qemu=qemu-system-x86_64
initrd=initrd.img
vmlinuz=/boot/vmlinuz-6.1.0-13-amd64

$qemu -m 1024 \
    -kernel $vmlinuz \
    -initrd $initrd \
    -enable-kvm \
    -net nic \
    -net user \
    -drive file=image.img,id=disk,if=none,format=raw \
    -device ahci,id=ahci \
    -device ide-hd,drive=disk,bus=ahci.0 \
    -append "console=ttyS0,115200n8 root=/dev/ram rd.shell=1" \
    -serial telnet:localhost:5555,server,nowait \
    -nographic

