SHELL := /bin/bash

# Dependency Versions
VERSION?=2.4.5
RELEASEVER?=1

# Bash data
SCRIPTPATH=$(shell pwd -P)
CORES=$(shell grep -c ^processor /proc/cpuinfo)
RELEASE=$(shell lsb_release --codename | cut -f2)

major=$(shell echo $(VERSION) | cut -d. -f1)
minor=$(shell echo $(VERSION) | cut -d. -f2)
micro=$(shell echo $(VERSION) | cut -d. -f3)

build: clean libassuan

clean:
	rm -rf /tmp/libassuan-$(VERSION)
	rm -rf /tmp/libassuan-$(VERSION).tar.bz2
	
libassuan:
	cd /tmp && \
	wget ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-$(VERSION).tar.bz2 && \
	tar -xf libassuan-$(VERSION).tar.bz2 && \
	cd libassuan-$(VERSION) && \
	mkdir -p /usr/share/man/libassuan/$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/libassuan/$(VERSION) \
	    --infodir=/usr/share/info/libassuan/$(VERSION) \
	    --docdir=/usr/share/doc/libassuan/$(VERSION) && \
	make -j$(CORES) && \
	make install

fpm_debian:
	echo "Packaging libassuan for Debian"

	cd /tmp/libassuan-$(VERSION) && make install DESTDIR=/tmp/libassuan-$(VERSION)-install

	mkdir -p /tmp/libassuan-$(VERSION)-install/etc/ld.so.conf.d/

	fpm -s dir \
		-t deb \
		-n libassuan \
		-v $(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2) \
		-C /tmp/libassuan-$(VERSION)-install \
		-p libassuan_$(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2)_$(shell arch).deb \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/librotli-build \
		--description "libassuan" \
		--deb-systemd-restart-after-upgrade

fpm_rpm:
	echo "Packaging libassuan for RPM"

	cd /tmp/libassuan-$(VERSION) && make install DESTDIR=/tmp/libassuan-$(VERSION)-install

	mkdir -p /tmp/libassuan-$(VERSION)-install/etc/ld.so.conf.d/

	fpm -s dir \
		-t rpm \
		-n libassuan \
		-v $(VERSION)_$(RELEASEVER) \
		-C /tmp/libassuan-install \
		-p libassuan_$(VERSION)-$(RELEASEVER)_$(shell arch).rpm \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/libassuan-build \
		--description "libassuan" \
		--vendor "Charles R. Portwood II" \
		--rpm-digest sha384 \
		--rpm-compression gzip
