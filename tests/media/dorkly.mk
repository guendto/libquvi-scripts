TEST_PROGS+=media_dorkly
media_dorkly_SOURCES=media/media_dorkly.c
media_dorkly_CPPFLAGS=$(testsuite_cppflags)
media_dorkly_LDFLAGS=$(testsuite_ldflags)
media_dorkly_LDADD=$(testsuite_ldadd)
media_dorkly_CFLAGS=$(AM_CFLAGS)
