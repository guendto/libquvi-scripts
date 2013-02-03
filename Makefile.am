ACLOCAL_AMFLAGS=-I m4
EXTRA_DIST=	gen-ver.sh libquvi-scripts-0.9.pc.in VERSION

SUBDIRS=	share
if WITH_MANUAL
SUBDIRS+=	doc
endif

pkgconfigdir=	$(libdir)/pkgconfig
pkgconfig_DATA=	libquvi-scripts-0.9.pc

.PHONY: doc test stamp_scripts ChangeLog VERSION

doc:
	@make -C $(top_builddir)/doc/man7/ doc

if WITH_TESTS
SUBDIRS+=	tests

check: test

test: all
	@(cd tests ; $(MAKE) test)
endif # WITH_TESTS

stamp_scripts:
	@if test -x "$(top_srcdir)/stamp.sh"; then \
		"$(top_srcdir)/stamp.sh" "`$(top_srcdir)/gen-ver.sh`" "$(top_distdir)"; \
	fi

VERSION:
	@if test -d "$(top_srcdir)/.git" -o -f "$(top_srcdir)/.git"; then \
		"$(top_srcdir)/gen-ver.sh" "$(top_srcdir)" > $@; \
	fi

ChangeLog:
	@if test -d "$(top_srcdir)/.git" -o -f "$(top_srcdir)/.git"; then \
		git log --stat --name-only --date=short --abbrev-commit > $@; \
	fi

dist-hook: VERSION stamp_scripts ChangeLog
