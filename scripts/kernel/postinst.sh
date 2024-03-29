#!/bin/sh -e

version="$1"
bootopt=""

command -v build_initrd.sh >/dev/null 2>&1 || exit 0

# passing the kernel version is required
if [ -z "${version}" ]; then
	echo >&2 "W: initramfs-tools: ${DPKG_MAINTSCRIPT_PACKAGE:-kernel package} did not pass a version number"
	exit 2
fi

# exit if kernel does not need an initramfs
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
	if [ -z "$1" ] || [ "$1" != "configure" ]; then
		exit 0
	fi
fi

# we're good - create initramfs.  update runs do_bootloader
# shellcheck disable=SC2086
build_initrd.sh -k "${version}" ${bootopt} >&2
