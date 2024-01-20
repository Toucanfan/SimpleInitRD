.PHONY: clean all initrd.img qemu install deb

INSTALL_ROOT ?= /
PREFIX := usr

all: initrd.img

initrd.img: _build
	rm -f initrd.img
	sudo scripts/build_initrd.sh -c . -t ./template -b .
	mv initrd.img-* initrd.img

_build:
	mkdir _build

qemu: initrd.img
	scripts/start_qemu.sh

define INSTALL_TO
mkdir -p $(1)/etc/simpleinitrd
install -m 644 settings.sh $(1)/etc/simpleinitrd
install -m 644 build_settings.sh $(1)/etc/simpleinitrd
install -m 655 scripts/build_initrd.sh $(1)/$(2)/sbin
install -m 655 -T scripts/kernel/postinst.sh $(1)/etc/kernel/postinst.d/SimpleInitRD
install -m 655 -T scripts/kernel/postrm.sh $(1)/etc/kernel/postrm.d/SimpleInitRD
cp -r template $(1)/etc/simpleinitrd/
endef

install:
	@echo "Installing into $(INSTALL_ROOT)/$(PREFIX)..."
	$(call INSTALL_TO,$(INSTALL_ROOT),$(PREFIX))

deb: _build
	rm -rf _build/dpkg
	mkdir -p _build/dpkg/DEBIAN
	cp scripts/control.dpkg _build/dpkg/DEBIAN/control
	mkdir -p _build/dpkg/etc/simpleinitrd
	mkdir -p _build/dpkg/etc/kernel/postinst.d
	mkdir -p _build/dpkg/etc/kernel/postrm.d
	mkdir -p _build/dpkg/usr/sbin
	$(call INSTALL_TO,_build/dpkg/,usr)
	cd _build && dpkg-deb --build dpkg
	
clean:
	sudo rm -rf _build initrd.img
