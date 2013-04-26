TEST_PROGS+=media_sevenload
media_sevenload_SOURCES=media/media_sevenload.c
media_sevenload_CPPFLAGS=$(testsuite_cppflags)
media_sevenload_LDFLAGS=$(testsuite_ldflags)
media_sevenload_LDADD=$(testsuite_ldadd)
media_sevenload_CFLAGS=$(AM_CFLAGS)
