TEST_PROGS+=media_metacafe
media_metacafe_SOURCES=media/media_metacafe.c
media_metacafe_CPPFLAGS=$(testsuite_cppflags)
media_metacafe_LDFLAGS=$(testsuite_ldflags)
media_metacafe_LDADD=$(testsuite_ldadd)
media_metacafe_CFLAGS=$(AM_CFLAGS)
