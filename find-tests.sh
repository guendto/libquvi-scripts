#!/bin/sh
#
# gen-test-skip.sh for libquvi-scripts
#
dir=tests/t/

note()
{
  echo "Run in the top source directory of libquvi-scripts"
  exit 0
}

[ -d "$dir" ] || note

echo "The test suite runs all found tests ($dir*.t) by default. To skip
any of these tests, define them in the TEST_SKIP enviroment.

Tests found:"
find "$dir" -name '*.t' |
  xargs grep test_skip |
    perl -ne'/test_skip."(.*?)"/ && print "  $1\n"'
echo "
Example:
  mkdir tmp ; cd tmp ; ../configure --with-tests
  env TEST_SKIP=mem,format_default script -c \"make check\""
