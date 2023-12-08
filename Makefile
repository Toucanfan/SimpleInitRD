.PHONY: clean all initrd.img qemu

all: initrd.img

initrd.img: _build
	cd _build && sudo ../scripts/build_initrd.sh
	cp _build/initrd.cpio.gz initrd.img

_build:
	mkdir _build

qemu: initrd.img
	scripts/start_qemu.sh

clean:
	sudo rm -rf _build initrd.img
