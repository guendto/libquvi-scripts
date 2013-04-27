TEST_PROGS+=media_theonion
media_theonion_SOURCES=media/media_theonion.c
media_theonion_CPPFLAGS=$(testsuite_cppflags)
media_theonion_LDFLAGS=$(testsuite_ldflags)
media_theonion_LDADD=$(testsuite_ldadd)
media_theonion_CFLAGS=$(AM_CFLAGS)
