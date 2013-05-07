TEST_PROGS+=media_ardmediathek
media_ardmediathek_SOURCES=media/media_ardmediathek.c
media_ardmediathek_CPPFLAGS=$(testsuite_cppflags)
media_ardmediathek_LDFLAGS=$(testsuite_ldflags)
media_ardmediathek_LDADD=$(testsuite_ldadd)
media_ardmediathek_CFLAGS=$(AM_CFLAGS)
