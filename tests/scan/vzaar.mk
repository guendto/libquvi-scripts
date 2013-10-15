TEST_PROGS+=scan_vzaar
scan_vzaar_SOURCES=scan/scan_vzaar.c
scan_vzaar_CPPFLAGS=$(testsuite_cppflags)
scan_vzaar_LDFLAGS=$(testsuite_ldflags)
scan_vzaar_LDADD=$(testsuite_ldadd)
scan_vzaar_CFLAGS=$(AM_CFLAGS)
