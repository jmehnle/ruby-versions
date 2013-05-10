MANIFEST_FILE   = MANIFEST
VERSION         = $(shell bin/ruby-versions config version)
SHIM_PATH       = $(shell bin/ruby-versions config shim_path)
PACKAGE         = ruby-versions-$(VERSION).tar.gz

all: ;

install:
	mkdir -p /usr/local/bin
	install -m 755 bin/ruby-versions /usr/local/bin/ruby-versions
	mkdir -p $(SHIM_PATH)
	/usr/local/bin/ruby-versions install

uninstall:
	/usr/local/bin/ruby-versions uninstall
	rm /usr/local/bin/ruby-versions
	rm -r $(SHIM_PATH)

dist: $(PACKAGE);

$(PACKAGE):
	tar -cz -T $(MANIFEST_FILE) -f $(PACKAGE)

clean: ;

distclean:
	rm $(PACKAGE)

.PHONY: all install uninstall dist clean distclean
