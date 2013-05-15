MANIFEST_FILE   = MANIFEST
VERSION         = $(shell ruby bin/ruby-versions config version)
REAL_RUBY       = $(shell ruby bin/ruby-versions which)
SHIM_PATH       = $(shell ruby bin/ruby-versions config shim_path)
PACKAGE         = ruby-versions-$(VERSION).tar.gz

INSTALLPATH_BIN = /usr/local/bin
INSTALLPATH_LIB = /usr/local/lib/ruby-versions

all: build build/bin/ruby-versions;

build:
	mkdir -p build
	mkdir build/bin

build/bin/ruby-versions:
	awk '{ if (NR == 1 && /^#!/) print "#!$(REAL_RUBY)"; else print }' bin/ruby-versions >build/bin/ruby-versions

install:
	mkdir -p $(INSTALLPATH_BIN)
	install -m 755 build/bin/ruby-versions $(INSTALLPATH_BIN)/ruby-versions
	mkdir -p $(INSTALLPATH_LIB)
	mkdir -p $(SHIM_PATH)
	$(INSTALLPATH_BIN)/ruby-versions install

uninstall:
	$(INSTALLPATH_BIN)/ruby-versions uninstall
	rm -r $(SHIM_PATH)
	rm -r $(INSTALLPATH_LIB)
	rm $(INSTALLPATH_BIN)/ruby-versions

dist: $(PACKAGE);

$(PACKAGE):
	tar -cz -T $(MANIFEST_FILE) -f $(PACKAGE)

clean:
	rm -r build

distclean: clean
	rm $(PACKAGE)

.PHONY: all build install uninstall dist clean distclean
