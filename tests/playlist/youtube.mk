TEST_PROGS+=playlist_youtube
playlist_youtube_SOURCES=playlist/playlist_youtube.c
playlist_youtube_CPPFLAGS=$(testsuite_cppflags)
playlist_youtube_LDFLAGS=$(testsuite_ldflags)
playlist_youtube_LDADD=$(testsuite_ldadd)
playlist_youtube_CFLAGS=$(AM_CFLAGS)
