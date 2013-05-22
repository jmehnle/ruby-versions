# This Makefile assumes GNU make.

MANIFEST_FILE       = MANIFEST
VERSION             = $(shell ruby bin/ruby-versions config version)
REAL_RUBY           = $(shell ruby bin/ruby-versions which)
SHIM_PATH           = $(DESTDIR)$(shell ruby bin/ruby-versions config shim_path)
PACKAGE             = ruby-versions-$(VERSION).tar.gz

INSTALLPATH_BIN     = $(DESTDIR)/usr/local/bin
INSTALLPATH_VAR_LIB = $(DESTDIR)/var/lib/ruby-versions

all: build build/bin/ruby-versions;

build:
	mkdir -p build
	mkdir -p build/bin

build/bin/ruby-versions:
	awk '{ if (NR == 1 && /^#!/) print "#!$(REAL_RUBY)"; else print }' bin/ruby-versions >build/bin/ruby-versions

install: all
	mkdir -p $(INSTALLPATH_BIN)
	install -m 755 build/bin/ruby-versions $(INSTALLPATH_BIN)/ruby-versions
	mkdir -p $(INSTALLPATH_VAR_LIB)
	mkdir -p $(SHIM_PATH)

uninstall:
	rm -rf $(SHIM_PATH)
	rm -rf $(INSTALLPATH_VAR_LIB)
	rm -f $(INSTALLPATH_BIN)/ruby-versions

dist: $(PACKAGE);

$(PACKAGE):
	tar -cz -T $(MANIFEST_FILE) -f $(PACKAGE)

clean:
	rm -rf build

distclean: clean
	rm -f $(PACKAGE)

.PHONY: all build install uninstall dist clean distclean
