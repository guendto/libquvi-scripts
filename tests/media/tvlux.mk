TEST_PROGS+=media_tvlux
media_tvlux_SOURCES=media/media_tvlux.c
media_tvlux_CPPFLAGS=$(testsuite_cppflags)
media_tvlux_LDFLAGS=$(testsuite_ldflags)
media_tvlux_LDADD=$(testsuite_ldadd)
media_tvlux_CFLAGS=$(AM_CFLAGS)
