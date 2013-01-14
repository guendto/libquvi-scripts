TEST_PROGS+=subtitle_youtube
subtitle_youtube_SOURCES=subtitle/subtitle_youtube.c
subtitle_youtube_CPPFLAGS=$(testsuite_cppflags)
subtitle_youtube_LDFLAGS=$(testsuite_ldflags)
subtitle_youtube_LDADD=$(testsuite_ldadd)
subtitle_youtube_CFLAGS=$(AM_CFLAGS)
