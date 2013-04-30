TEST_PROGS+=media_liveleak
media_liveleak_SOURCES=media/media_liveleak.c
media_liveleak_CPPFLAGS=$(testsuite_cppflags)
media_liveleak_LDFLAGS=$(testsuite_ldflags)
media_liveleak_LDADD=$(testsuite_ldadd)
media_liveleak_CFLAGS=$(AM_CFLAGS)
