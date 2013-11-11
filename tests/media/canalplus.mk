TEST_PROGS+=media_canalplus
media_canalplus_SOURCES=media/media_canalplus.c
media_canalplus_CPPFLAGS=$(testsuite_cppflags)
media_canalplus_LDFLAGS=$(testsuite_ldflags)
media_canalplus_LDADD=$(testsuite_ldadd)
media_canalplus_CFLAGS=$(AM_CFLAGS)
