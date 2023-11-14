all: install

install:
	sudo install -Dm755 rhino-pkg -t $(DESTDIR)/usr/bin/
