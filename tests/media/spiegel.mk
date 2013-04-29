TEST_PROGS+=media_spiegel
media_spiegel_SOURCES=media/media_spiegel.c
media_spiegel_CPPFLAGS=$(testsuite_cppflags)
media_spiegel_LDFLAGS=$(testsuite_ldflags)
media_spiegel_LDADD=$(testsuite_ldadd)
media_spiegel_CFLAGS=$(AM_CFLAGS)
