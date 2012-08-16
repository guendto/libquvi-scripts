TEST_PROGS+=media_youtube
media_youtube_SOURCES=media/media_youtube.c
media_youtube_CPPFLAGS=$(testsuite_cppflags)
media_youtube_LDFLAGS=$(testsuite_ldflags)
media_youtube_LDADD=$(testsuite_ldadd)
media_youtube_CFLAGS=$(AM_CFLAGS)
