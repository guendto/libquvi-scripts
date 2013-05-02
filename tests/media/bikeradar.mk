TEST_PROGS+=media_bikeradar
media_bikeradar_SOURCES=media/media_bikeradar.c
media_bikeradar_CPPFLAGS=$(testsuite_cppflags)
media_bikeradar_LDFLAGS=$(testsuite_ldflags)
media_bikeradar_LDADD=$(testsuite_ldadd)
media_bikeradar_CFLAGS=$(AM_CFLAGS)
