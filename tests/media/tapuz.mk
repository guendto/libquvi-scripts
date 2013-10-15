TEST_PROGS+=media_tapuz
media_tapuz_SOURCES=media/media_tapuz.c
media_tapuz_CPPFLAGS=$(testsuite_cppflags)
media_tapuz_LDFLAGS=$(testsuite_ldflags)
media_tapuz_LDADD=$(testsuite_ldadd)
media_tapuz_CFLAGS=$(AM_CFLAGS)
