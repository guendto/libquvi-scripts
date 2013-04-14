#!/bin/sh
#
# libquvi-scripts
# Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
#
# This file part of libquvi-scripts <http://quvi.sourceforge.net/>.
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General
# Public License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.
#
set -e

# cmds
Z='zenity'
# arrays
T= # tests

find_tests()
{
  f="`dirname $0`/find_tests.sh"
  T=`$f | sort -hr` || {
    echo "error: $! ($?)"
    exit 1
  }
  [ -n "$T" ] || {
    echo "error: tests not found"
    exit 1
  }
}

enter_custom_test_skip()
{
  T=`$Z --entry --text="Enter:" \
    --entry-text="(comma-separated, patterns OK)" \
    --width=320 --height=180 \
    --title="Enter a custom value for TEST_SKIP"`
  export TEST_SKIP="$T"
  echo "TEST_SKIP=$TEST_SKIP"
  return 0
}

choose_skipped_tests()
{
  a=; for t in $T; do
    a="FALSE $t $a"
  done
  o='--list --width 320 --height 480 --separator=,'
  o="$o --column Skip --column Test"
  T=`$Z $o --checklist false enter_custom $a`
  expr "$T" : ".*enter_custom.*" >/dev/null && enter_custom_test_skip
  export TEST_SKIP="$T"
#  echo "TEST_SKIP=$TEST_SKIP"
  return 0
}

choose_test_level()
{
  o='--list --radiolist --width 320 --height 240'
  o="$o --column Enable --column Level true basic false complete"
  T=`$Z $o`
  export TEST_LEVEL="$T"
#  echo "TEST_LEVEL=$TEST_LEVEL"
  return 0
}

choose_test_opts()
{
  c='--column Enable --column Test'
  a='false TEST_GEOBLOCKED false TEST_VERBOSE false TEST_NSFW false TEST_FIXME'
  r=`$Z --width 320 --height 240 --list --checklist $c $a`
  expr "$r" : ".*GEOBLOCKED.*" >/dev/null && export TEST_GEOBLOCKED=1
  expr "$r" : ".*VERBOSE.*" >/dev/null && export TEST_VERBOSE=1
  expr "$r" : ".*FIXME.*" >/dev/null && export TEST_FIXME=1
  expr "$r" : ".*NSFW.*" >/dev/null && export TEST_NSFW=1
  return 0
}

run_tests()
{
  echo "TEST_GEOBLOCKED=$TEST_GEOBLOCKED"
  echo "TEST_VERBOSE=$TEST_VERBOSE"
  echo "TEST_FIXME=$TEST_FIXME"
  echo "TEST_NSFW=$TEST_NSFW"
  make test
  return 0
}

help()
{
  echo "Usage: $0 [OPTIONS]

$0 is a convenience script for running the tests.

OPTIONS
  -h  Show this help and exit

NOTE: Run 'configure' script first

  Example:
    cd \$top_srcdir ; mkdir tmp ; cd tmp
    ../configure && make && ../$0

$0 sets the following environment variables before
running the tests:
  TEST_GEOBLOCKED
  TEST_VERBOSE
  TEST_FIXME
  TEST_NSFW
  TEST_SKIP

NOTE: You must set any HTTP proxy environment variables (e.g.
http_proxy) manually. Refer to curl(1) manual page for a list
of the supported variables."
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    -h) help;;
    *) break;;
  esac
  shift
done

[ -f "config.log" ] || {
  echo "error: config.log not found: have you run configure?"
  exit 1
}

find_tests
choose_skipped_tests
choose_test_level
choose_test_opts
run_tests

# vim: set ts=2 sw=2 tw=72 expandtab:
