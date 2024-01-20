.PHONY: clean all initrd.img qemu install

INSTALL_ROOT ?= 

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
	@echo "Installing into $(INSTALL_ROOT)/..."
	mkdir -p $(INSTALL_ROOT)/etc/simpleinitrd
	install -m 644 settings.sh $(INSTALL_ROOT)/etc/simpleinitrd
	install -m 644 build_settings.sh $(INSTALL_ROOT)/etc/simpleinitrd
	install -m 655 scripts/build_initrd.sh $(INSTALL_ROOT)/usr/local/sbin
	install -m 655 -T scripts/kernel/postinst.sh $(INSTALL_ROOT)/etc/kernel/postinst.d/SimpleInitRD
	install -m 655 -T scripts/kernel/postrm.sh $(INSTALL_ROOT)/etc/kernel/postrm.d/SimpleInitRD
	cp -r template $(INSTALL_ROOT)/etc/simpleinitrd/

clean:
	sudo rm -rf _build initrd.img
