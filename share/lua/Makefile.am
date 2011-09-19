
nobase_dist_pkgdata_DATA=	version
DISTCLEANFILES=	version
EXTRA_DIST=	version

.PHONY: version

version:
	@if test -d "$(top_srcdir)/.git" -o -f "$(top_srcdir)/.git"; then \
		"$(top_srcdir)/gen-ver.sh" "$(top_srcdir)" > $@; \
	fi

dist-hook: version
