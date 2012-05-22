
TESTS_T=\
 t/format_default.t \
 t/format_other.t \
 t/shortened.t \
 t/nosupport.t \
 t/expire.t

if WITH_FIXME
TESTS_T+=t/redirect.t # TODO: Uses scripts marked as FIXME; use new URLs.
TESTS_T+=t/mem.t # TODO: Ditto.
endif

TESTS_D_T=	t/d/url.t
TESTS_LIB=	lib/Test/Quvi.pm
TESTS_JSON=	data

EXTRA_DIST=\
 README \
 $(TESTS_NSFW_T) \
 $(TESTS_JSON) \
 $(TESTS_LIB) \
 $(TESTS_D_T) \
 $(TESTS_T)

PROVE_OPTS=	-I $(top_srcdir)/tests/lib/
PROVE_OPTS+=	--nocolor

TESTQUVI_OPTS=\
 -q $(QUVI) \
 -d $(top_srcdir)/tests \
 -b $(top_srcdir)/share

if HAVE_VALGRIND
TESTQUVI_OPTS+=	-v $(VALGRIND)
endif

if WITH_FIXME
TESTQUVI_OPTS+=	--fixme
endif

if WITH_NLFY
TESTQUVI_OPTS+=	--nlfy
endif

if WITH_NSFW
TESTQUVI_OPTS+=	--nsfw
endif

test: all
	@verbose=; test -n "$$TEST_VERBOSE" && verbose=-v; \
	ok=1; for t in $(TESTS_T); do \
		( $(PROVE) $$verbose $(PROVE_OPTS) $(top_srcdir)/tests/$$t \
		:: $(TESTQUVI_OPTS) ) || ok=; \
	done; \
	if test -z "$$ok"; then exit 1; fi
