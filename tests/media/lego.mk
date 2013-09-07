TEST_PROGS+=media_lego
media_lego_SOURCES=media/media_lego.c
media_lego_CPPFLAGS=$(testsuite_cppflags)
media_lego_LDFLAGS=$(testsuite_ldflags)
media_lego_LDADD=$(testsuite_ldadd)
media_lego_CFLAGS=$(AM_CFLAGS)
