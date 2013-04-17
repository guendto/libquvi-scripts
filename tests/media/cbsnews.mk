TEST_PROGS+=media_cbsnews
media_cbsnews_SOURCES=media/media_cbsnews.c
media_cbsnews_CPPFLAGS=$(testsuite_cppflags)
media_cbsnews_LDFLAGS=$(testsuite_ldflags)
media_cbsnews_LDADD=$(testsuite_ldadd)
media_cbsnews_CFLAGS=$(AM_CFLAGS)
