TEST_PROGS+=scan_youtube
scan_youtube_SOURCES=scan/scan_youtube.c
scan_youtube_CPPFLAGS=$(testsuite_cppflags)
scan_youtube_LDFLAGS=$(testsuite_ldflags)
scan_youtube_LDADD=$(testsuite_ldadd)
scan_youtube_CFLAGS=$(AM_CFLAGS)
