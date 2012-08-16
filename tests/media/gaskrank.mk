TEST_PROGS+=media_gaskrank
media_gaskrank_SOURCES=media/media_gaskrank.c
media_gaskrank_CPPFLAGS=$(testsuite_cppflags)
media_gaskrank_LDFLAGS=$(testsuite_ldflags)
media_gaskrank_LDADD=$(testsuite_ldadd)
media_gaskrank_CFLAGS=$(AM_CFLAGS)
