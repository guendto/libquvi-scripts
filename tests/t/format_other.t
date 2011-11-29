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
  if $q->test_skip("format_other");

my @files = $q->find_json(
  qw(
    data/format/other
    data/format/default/ignore/length_bytes
    )
);

plan skip_all => "Nothing to test" if scalar @files == 0;
plan tests => scalar @files * 2;

my $j   = $q->get_json_obj;
my $ign = qr|/ignore/(.*?)/|;

foreach (@files)
{
  my $e = $q->read_json($_);

  $q->mark_ignored(\$e, $1) if $_ =~ /$ign/;

  my $f = $e->{format_requested};
  my ($r, $o) = $q->run($e->{page_url}, "-vq -e-r -f $f");
  is($r, 0, "quvi exit status == 0")
    or diag $e->{page_url};
SKIP:
  {
    skip 'quvi exit status != 0', 1 if $r != 0;
    cmp_deeply($j->decode($o), $e, "compare with $_")
      or diag $e->{page_url};
  }
}

# vim: set ts=2 sw=2 tw=72 expandtab:
