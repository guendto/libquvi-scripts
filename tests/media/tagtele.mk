TEST_PROGS+=media_tagtele
media_tagtele_SOURCES=media/media_tagtele.c
media_tagtele_CPPFLAGS=$(testsuite_cppflags)
media_tagtele_LDFLAGS=$(testsuite_ldflags)
media_tagtele_LDADD=$(testsuite_ldadd)
media_tagtele_CFLAGS=$(AM_CFLAGS)
