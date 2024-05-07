# This checks to make sure that DESTDIR is defined before initiation the install. \
	if it is not, it informs the user they must define it and exits with an error code.
all::
ifndef DESTDIR 
	@echo "There was no destination given for the install. Please rerun while setting the variable DESTDIR in the command line." 
	exit 1
endif

# Actually makes rhino-pkg, provided that DESTDIR is defined
all:: make-dirs translation-tomls rhino-pkg

install: all

make-dirs:
mkdir -p $(DESTDIR)/usr/bin
mkdir -p $(DESTDIR)/usr/share/rhino-pkg/


# Copies translation-tomls recursively. 
translation-tomls:
	cp -r ./translation-tomls $(DESTDIR)/usr/share/rhino-pkg

rhino-pkg:
# Copies over rhino-pkg's nu-files
	cp -r ./nu-files $(DESTDIR)/usr/share/rhino-pkg-git
# Sets up the usr/bin directory and symlinks the rhino-pkg executable into it as rhino-pkg and rpk 
	ln -sf $(DESTDIR)/usr/share/rhino-pkg/nu-files/rhino-pkg $(DESTDIR)/usr/bin/rhino-pkg
	ln -sf $(DESTDIR)usr/share/rhino-pkg/nu-files/rhino-pkg $(DESTDIR)/usr/bin/rpk
