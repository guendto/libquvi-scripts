TEST_PROGS+=media_charlierose
media_charlierose_SOURCES=media/media_charlierose.c
media_charlierose_CPPFLAGS=$(testsuite_cppflags)
media_charlierose_LDFLAGS=$(testsuite_ldflags)
media_charlierose_LDADD=$(testsuite_ldadd)
media_charlierose_CFLAGS=$(AM_CFLAGS)
