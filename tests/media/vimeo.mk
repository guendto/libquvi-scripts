TEST_PROGS+=media_vimeo
media_vimeo_SOURCES=media/media_vimeo.c
media_vimeo_CPPFLAGS=$(testsuite_cppflags)
media_vimeo_LDFLAGS=$(testsuite_ldflags)
media_vimeo_LDADD=$(testsuite_ldadd)
media_vimeo_CFLAGS=$(AM_CFLAGS)
