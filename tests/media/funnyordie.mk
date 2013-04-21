TEST_PROGS+=media_funnyordie
media_funnyordie_SOURCES=media/media_funnyordie.c
media_funnyordie_CPPFLAGS=$(testsuite_cppflags)
media_funnyordie_LDFLAGS=$(testsuite_ldflags)
media_funnyordie_LDADD=$(testsuite_ldadd)
media_funnyordie_CFLAGS=$(AM_CFLAGS)
