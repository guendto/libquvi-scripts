TEST_PROGS+=media_videa
media_videa_SOURCES=media/media_videa.c
media_videa_CPPFLAGS=$(testsuite_cppflags)
media_videa_LDFLAGS=$(testsuite_ldflags)
media_videa_LDADD=$(testsuite_ldadd)
media_videa_CFLAGS=$(AM_CFLAGS)
