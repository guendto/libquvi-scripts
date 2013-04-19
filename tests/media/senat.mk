TEST_PROGS+=media_senat
media_senat_SOURCES=media/media_senat.c
media_senat_CPPFLAGS=$(testsuite_cppflags)
media_senat_LDFLAGS=$(testsuite_ldflags)
media_senat_LDADD=$(testsuite_ldadd)
media_senat_CFLAGS=$(AM_CFLAGS)
