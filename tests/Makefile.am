SUBDIRS=lib
noinst_PROGRAMS=$(TEST_PROGS)

TEST_PROGS=
TEST_OPTS=-k -m=thorough --verbose #--g-fatal-warnings

testsuite_cppflags=\
  -I$(top_srcdir)/tests/lib\
  $(libquvi_CFLAGS) $(libcurl_CFLAGS) $(glib_CFLAGS)\
  $(AM_CPPFLAGS)

testsuite_ldflags=\
  $(AM_LDFLAGS)

testsuite_ldadd=\
  $(top_builddir)/tests/lib/libconvenience_test.la\
  $(libquvi_LIBS) $(libcurl_LIBS) $(glib_LIBS)

include $(top_srcdir)/tests/playlist/tests.mk
include $(top_srcdir)/tests/subtitle/tests.mk
include $(top_srcdir)/tests/media/tests.mk
include $(top_srcdir)/tests/scan/tests.mk

test: all
	@ok=1; for t in $(TEST_PROGS); do \
		LIBQUVI_EXCLUSIVE_SCRIPTS_DIR=1 LIBQUVI_SCRIPTS_DIR=$(top_srcdir)/share/ \
			gtester $(TEST_OPTS) $(top_builddir)/tests/$$t -o $$t.xml \
		|| { \
			echo NOTE: Check $(abs_builddir)/$$t.xml for details; ok=; \
		} \
	done; \
	if test -z "$$ok"; then exit 1; fi

clean-local:
	@for t in $(TEST_PROGS); do rm -f $$t.xml $$t.html; done

EXTRA_DIST=find_tests.sh run_tests.sh
