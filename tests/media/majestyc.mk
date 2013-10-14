TEST_PROGS+=media_majestyc
media_majestyc_SOURCES=media/media_majestyc.c
media_majestyc_CPPFLAGS=$(testsuite_cppflags)
media_majestyc_LDFLAGS=$(testsuite_ldflags)
media_majestyc_LDADD=$(testsuite_ldadd)
media_majestyc_CFLAGS=$(AM_CFLAGS)
