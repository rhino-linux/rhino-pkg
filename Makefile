all: install

install:
	mkdir -pv $(DESTDIR)/usr/share/rhino-pkg/
	cp -rv modules/ $(DESTDIR)/usr/share/rhino-pkg/
	install -Dm755 rhino-pkg -t $(DESTDIR)/usr/bin/
