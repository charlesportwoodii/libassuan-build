SHELL := /bin/bash

# Dependency Versions
VERSION?=2.4.2
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
	mkdir -p /usr/share/man/libassuan-$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/libassuan-$(VERSION) \
	    --infodir=/usr/share/info/libassuan-$(VERSION) \
	    --docdir=/usr/share/doc/libassuan-$(VERSION) && \
	make -j$(CORES) && \
	make install

package:
	cd /tmp/libassuan-$(VERSION) && \
	checkinstall \
	    -D \
	    --fstrans \
	    -pkgrelease "$(RELEASEVER)"-"$(RELEASE)" \
	    -pkgrelease "$(RELEASEVER)"~"$(RELEASE)" \
	    -pkgname "libassuan" \
	    -pkglicense GPLv3 \
	    -pkggroup GPG \
	    -maintainer charlesportwoodii@ethreal.net \
	    -provides "libassuan-$(VERSION)" \
	    -pakdir /tmp \
	    -y