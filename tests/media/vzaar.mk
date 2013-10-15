TEST_PROGS+=media_vzaar
media_vzaar_SOURCES=media/media_vzaar.c
media_vzaar_CPPFLAGS=$(testsuite_cppflags)
media_vzaar_LDFLAGS=$(testsuite_ldflags)
media_vzaar_LDADD=$(testsuite_ldadd)
media_vzaar_CFLAGS=$(AM_CFLAGS)
