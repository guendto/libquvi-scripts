TEST_PROGS+=media_guardian
media_guardian_SOURCES=media/media_guardian.c
media_guardian_CPPFLAGS=$(testsuite_cppflags)
media_guardian_LDFLAGS=$(testsuite_ldflags)
media_guardian_LDADD=$(testsuite_ldadd)
media_guardian_CFLAGS=$(AM_CFLAGS)
