src=\
  env.c\
  fetch.c\
  qm_test.c\
  qp_test.c\
  qs_test.c\
  qsub_test.c\
  re.c\
  slist.c

hdr=tests.h

noinst_LTLIBRARIES=libconvenience_test.la
libconvenience_test_la_SOURCES=$(src) $(hdr)

libconvenience_test_la_CPPFLAGS=\
  -I$(top_srcdir)/tests/lib/\
  $(libquvi_CFLAGS)\
  $(libcurl_CFLAGS)\
  $(glib_CFLAGS)\
  $(AM_CPPFLAGS)

libconvenience_test_la_LDFLAGS=\
  $(AM_LDFLAGS)

libconvenience_test_la_LIBADD=\
  $(libquvi_LIBS)\
  $(libcurl_LIBS)\
  $(glib_LIBS)
