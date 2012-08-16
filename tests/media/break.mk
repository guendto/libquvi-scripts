TEST_PROGS+=media_break
media_break_SOURCES=media/media_break.c
media_break_CPPFLAGS=$(testsuite_cppflags)
media_break_LDFLAGS=$(testsuite_ldflags)
media_break_LDADD=$(testsuite_ldadd)
media_break_CFLAGS=$(AM_CFLAGS)
