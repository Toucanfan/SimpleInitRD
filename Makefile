.PHONY: clean all initrd.img qemu install

all: initrd.img

initrd.img: _build
	rm -f initrd.img
	sudo scripts/build_initrd.sh -c . -t ./template -b .
	mv initrd.img-* initrd.img

_build:
	mkdir _build

qemu: initrd.img
	scripts/start_qemu.sh

install:
	install 

clean:
	sudo rm -rf _build initrd.img
