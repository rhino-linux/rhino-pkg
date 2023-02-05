all: install

install:
	for i in po/*.po; do lang="$$(basename "$$i" .po)" && sudo mkdir -p $(DESTDIR)/usr/share/locale/"$$lang"/LC_MESSAGES/ && sudo msgfmt -o $(DESTDIR)/usr/share/locale/"$$lang"/LC_MESSAGES/rhino-pkg.mo po/"$$lang".po ; done
	sudo install -Dm755 rhino-pkg -t $(DESTDIR)/usr/bin/
