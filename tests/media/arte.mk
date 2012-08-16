TEST_PROGS+=media_arte
media_arte_SOURCES=media/media_arte.c
media_arte_CPPFLAGS=$(testsuite_cppflags)
media_arte_LDFLAGS=$(testsuite_ldflags)
media_arte_LDADD=$(testsuite_ldadd)
media_arte_CFLAGS=$(AM_CFLAGS)
