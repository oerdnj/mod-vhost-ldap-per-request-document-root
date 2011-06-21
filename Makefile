APXS=apxs2
VERSION := $(shell cat VERSION)
DISTFILES := $(shell cat FILES)
TMPDIR := $(shell mktemp -d /tmp/mod-vhost-ldap.XXXXXXXX)

all: mod_vhost_ldap.o

install:
	$(APXS) -i mod_vhost_ldap.la

clean:
	rm -f *.o
	rm -f *.lo
	rm -f *.la
	rm -f *.slo
	rm -rf .libs
	rm -rf mod_vhost_ldap-$(VERSION)
	rm -rf mod_vhost_ldap-$(VERSION).tar.gz

mod_vhost_ldap.o: mod_vhost_ldap.c
	# Try building with per request document root and if it fails, do the normal build (kinda ugly, but should work)
	$(APXS) -Wc,-Wall -Wc,-Werror -Wc,-g -Wc,-DDEBUG -Wc,-DMOD_VHOST_LDAP_VERSION=\\\"mod_vhost_ldap/$(VERSION)\\\" -Wc,-DHAS_PER_REQUEST_DOCUMENT_ROOT -c -lldap_r mod_vhost_ldap.c || \
	$(APXS) -Wc,-Wall -Wc,-Werror -Wc,-g -Wc,-DDEBUG -Wc,-DMOD_VHOST_LDAP_VERSION=\\\"mod_vhost_ldap/$(VERSION)\\\" -c -lldap_r mod_vhost_ldap.c

archive:
	git clone $(CURDIR) $(TMPDIR)/mod-vhost-ldap-$(VERSION)
	cd $(TMPDIR)/mod-vhost-ldap-$(VERSION) && \
	git checkout upstream
	cd $(TMPDIR) && \
	tar --exclude-vcs --exclude debian/ -czf $(CURDIR)/../mod-vhost-ldap-$(VERSION).tar.gz mod-vhost-ldap-$(VERSION)

format:
	indent *.c

.PHONY: all install clean archive format
