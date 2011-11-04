# libquvi-scripts
# Copyright (C) 2011  Toni Gundogdu <legatvs@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

use warnings;
use strict;

use Test::More;

eval "use JSON::XS";
plan skip_all => "JSON::XS required for testing" if $@;

eval "use Test::Deep";
plan skip_all => "Test::Deep required for testing" if $@;

use Test::Quvi;

my $q = Test::Quvi->new;

plan skip_all => "TEST_SKIP rule"
  if $q->test_skip("shortened");

plan tests => 4;

# All roads lead to (same) URL.
my @u = (

  # Resolved without querying over the internet.
  "http://dai.ly/cityofscars",

  # Query over the internet to resolved this one.
  "http://goo.gl/18ol"
);

my $f = "data/resolve/shortened.json";

# 1=prepend --data-root (if specified in cmdline)
my $e = $q->read_json($f, 1);

# dailymotion returns content-length that varies from
# time to time, no idea why.
$q->mark_ignored(\$e, 'length_bytes');

foreach (@u)
{
  my ($r, $o) = $q->run($_, "-q");
  is($r, 0, "quvi exit status == 0")
    or diag $_;
SKIP:
  {
    skip 'quvi exit status != 0', 1 if $r != 0;
    my $j = $q->get_json_obj;
    cmp_deeply($j->decode($o), $e, "compare with $f")
      or diag $_;
  }
}

# vim: set ts=2 sw=2 tw=72 expandtab:
