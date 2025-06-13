SHELL := /usr/bin/env bash

all: install

install:
	mapfile -t linguas <po/LINGUAS && for i in "$${linguas[@]}"; do mkdir -p $(DESTDIR)/usr/share/locale/"$${i}"/LC_MESSAGES/ && msgfmt -o $(DESTDIR)/usr/share/locale/"$${i}"/LC_MESSAGES/rhino-pkg.mo po/"$${i}".po; done
	mkdir -pv $(DESTDIR)/usr/share/rhino-pkg/
	cp -rv modules/ $(DESTDIR)/usr/share/rhino-pkg/
	install -Dm755 rhino-pkg -t $(DESTDIR)/usr/bin/
