TEST_PROGS+=media_clipfish
media_clipfish_SOURCES=media/media_clipfish.c
media_clipfish_CPPFLAGS=$(testsuite_cppflags)
media_clipfish_LDFLAGS=$(testsuite_ldflags)
media_clipfish_LDADD=$(testsuite_ldadd)
media_clipfish_CFLAGS=$(AM_CFLAGS)
