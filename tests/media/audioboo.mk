TEST_PROGS+=media_audioboo
media_audioboo_SOURCES=media/media_audioboo.c
media_audioboo_CPPFLAGS=$(testsuite_cppflags)
media_audioboo_LDFLAGS=$(testsuite_ldflags)
media_audioboo_LDADD=$(testsuite_ldadd)
media_audioboo_CFLAGS=$(AM_CFLAGS)
