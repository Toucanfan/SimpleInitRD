#!/bin/sh
#
qemu=qemu-system-x86_64
initrd=initrd.img

$qemu -m 1024 \
    -kernel /boot/vmlinuz-6.1.0-13-amd64 \
    -initrd $initrd \
    -drive file=image.img,if=ide,format=raw\
    -append "root=/dev/ram" \
    -append "console=ttyS0,115200n8" \
    -serial telnet:localhost:5555,server,nowait \
    -nographic
