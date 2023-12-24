#!/bin/bash

initrd_dir="initrd"
initrd_out="initrd.cpio"
kernel_ver=$(uname -r)
moddir="/lib/modules/$kernel_ver"

source ../build_settings.sh

# Functions
install_bin() {
    binary=$1

    lib_deps="$(ldd $binary | grep "=>" | awk '{print $3}')"

    install -t $initrd_dir/bin $binary
    install -t $initrd_dir/lib $lib_deps
}

install_module() {
    module="$1"
    mod_deps="$(modprobe --show-depends $module | awk '{print $2}')"
    mkdir -p $initrd_dir/$moddir
    for m in $mod_deps; do
        mkdir -p $initrd_dir/$(dirname $m)
        cp $m $initrd_dir/$m
    done
}

install_symlink() {
    link=$1
    symlink=$(basename $(which $link))
    binary=$(basename $(readlink $(which $link)))
    ln -s /bin/$binary $initrd_dir/bin/$symlink
}


#### SCRIPT #####

if [ "$EUID" != 0 ]; then
    echo "Run script as root!"
    exit 1
fi

# Remove existing build
rm -f $initrd_out.gz
if [ -d $initrd_dir ]; then
    umount $initrd_dir/sys 2>/dev/null
    umount $initrd_dir/proc 2>/dev/null
    umount $initrd_dir/dev 2>/dev/null
    rm -rf $initrd_dir
fi

# Create directory structure
mkdir -p $initrd_dir/{bin,dev,etc,lib,lib64,mnt,proc,run,sbin,sys,tmp,var}

# Install basics
cp $(which busybox) $initrd_dir/bin/
chroot $initrd_dir /bin/busybox --install -s /bin
cp -r ../template/* $initrd_dir/
ln -r -s $initrd_dir/lib $initrd_dir/lib/x86_64-linux-gnu
install -t $initrd_dir/lib /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
ln -r -s $initrd_dir/lib/ld-linux-x86-64.so.2 $initrd_dir/lib64/ld-linux-x86-64.so.2
cp /usr/lib/systemd/systemd-udevd $initrd_dir/bin/udevd
cp -r /lib/udev $initrd_dir/lib/udev
cp -r /etc/udev $initrd_dir/etc/udev
cp /usr/share/hwdata/pci.ids $initrd_dir/
cp ../settings.sh $initrd_dir/etc/

# Install desired binaries and dependencies
for bin in $BINARIES; do
    install_bin $(which $bin)
done
ldconfig -r $initrd_dir

for link in $SYMLINKS; do
    install_symlink $link
done

for mod in $MODULES; do
    install_module $mod
done
cp $moddir/modules.* $initrd_dir/$moddir/

# Install extra files
for file in $FILES; do
    mkdir -p $initrd_dir/$(dirname $file)
    cp -r $file $initrd_dir/$file
done

# Create archive
cd $initrd_dir && find . | cpio -o -H newc > ../$initrd_out
cd ..
gzip $initrd_out
