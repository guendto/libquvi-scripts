#!/bin/sh
#
# find-tests.sh for libquvi-scripts
# Copyright (C) 2011  Toni Gundogdu
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301  USA
#
set -e
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
