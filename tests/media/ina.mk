TEST_PROGS+=media_ina
media_ina_SOURCES=media/media_ina.c
media_ina_CPPFLAGS=$(testsuite_cppflags)
media_ina_LDFLAGS=$(testsuite_ldflags)
media_ina_LDADD=$(testsuite_ldadd)
media_ina_CFLAGS=$(AM_CFLAGS)
