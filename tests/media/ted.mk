TEST_PROGS+=media_ted
media_ted_SOURCES=media/media_ted.c
media_ted_CPPFLAGS=$(testsuite_cppflags)
media_ted_LDFLAGS=$(testsuite_ldflags)
media_ted_LDADD=$(testsuite_ldadd)
media_ted_CFLAGS=$(AM_CFLAGS)
