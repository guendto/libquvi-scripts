TEST_PROGS+=media_myspass
media_myspass_SOURCES=media/media_myspass.c
media_myspass_CPPFLAGS=$(testsuite_cppflags)
media_myspass_LDFLAGS=$(testsuite_ldflags)
media_myspass_LDADD=$(testsuite_ldadd)
media_myspass_CFLAGS=$(AM_CFLAGS)
