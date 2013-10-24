TEST_PROGS+=media_videobash
media_videobash_SOURCES=media/media_videobash.c
media_videobash_CPPFLAGS=$(testsuite_cppflags)
media_videobash_LDFLAGS=$(testsuite_ldflags)
media_videobash_LDADD=$(testsuite_ldadd)
media_videobash_CFLAGS=$(AM_CFLAGS)
