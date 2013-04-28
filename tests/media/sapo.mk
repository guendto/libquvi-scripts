TEST_PROGS+=media_sapo
media_sapo_SOURCES=media/media_sapo.c
media_sapo_CPPFLAGS=$(testsuite_cppflags)
media_sapo_LDFLAGS=$(testsuite_ldflags)
media_sapo_LDADD=$(testsuite_ldadd)
media_sapo_CFLAGS=$(AM_CFLAGS)
