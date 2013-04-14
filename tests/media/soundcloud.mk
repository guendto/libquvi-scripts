TEST_PROGS+=media_soundcloud
media_soundcloud_SOURCES=media/media_soundcloud.c
media_soundcloud_CPPFLAGS=$(testsuite_cppflags)
media_soundcloud_LDFLAGS=$(testsuite_ldflags)
media_soundcloud_LDADD=$(testsuite_ldadd)
media_soundcloud_CFLAGS=$(AM_CFLAGS)
