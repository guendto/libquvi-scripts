TEST_PROGS+=media_dailymotion
media_dailymotion_SOURCES=media/media_dailymotion.c
media_dailymotion_CPPFLAGS=$(testsuite_cppflags)
media_dailymotion_LDFLAGS=$(testsuite_ldflags)
media_dailymotion_LDADD=$(testsuite_ldadd)
media_dailymotion_CFLAGS=$(AM_CFLAGS)
