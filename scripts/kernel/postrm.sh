#!/bin/sh -e

version="$1"
bootopt=""

# passing the kernel version is required
if [ -z "${version}" ]; then
	echo >&2 "W: initramfs-tools: ${DPKG_MAINTSCRIPT_PACKAGE:-kernel package} did not pass a version number"
	exit 0
fi

# exit if custom kernel does not need an initramfs
if [ "$INITRD" = 'No' ]; then
	exit 0
fi

# absolute file name of kernel image may be passed as a second argument;
# create the initrd in the same directory
if [ -n "$2" ]; then
	bootdir=$(dirname "$2")
	bootopt="-b ${bootdir}"
fi

# avoid running multiple times
if [ -n "$DEB_MAINT_PARAMS" ]; then
	eval set -- "$DEB_MAINT_PARAMS"
	if [ -z "$1" ] || [ "$1" != "remove" ]; then
		exit 0
	fi
fi

# delete initramfs
# shellcheck disable=SC2086
rm -f $bootdir/initrd.img-${version}
