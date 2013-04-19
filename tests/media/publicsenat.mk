TEST_PROGS+=media_publicsenat
media_publicsenat_SOURCES=media/media_publicsenat.c
media_publicsenat_CPPFLAGS=$(testsuite_cppflags)
media_publicsenat_LDFLAGS=$(testsuite_ldflags)
media_publicsenat_LDADD=$(testsuite_ldadd)
media_publicsenat_CFLAGS=$(AM_CFLAGS)
