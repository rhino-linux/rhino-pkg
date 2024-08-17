SHELL := /usr/bin/env bash

all: install

install:
	read -r -a linguas < po/LINGUAS && for i in "$${linguas[@]}"; do mkdir -p $(DESTDIR)/usr/share/locale/"$${i}"/LC_MESSAGES/ &&  msgfmt -o $(DESTDIR)/usr/share/locale/"$${i}"/LC_MESSAGES/rhino-pkg.mo po/"$${i}".po; done
	install -Dm755 rhino-pkg -t $(DESTDIR)/usr/bin/
