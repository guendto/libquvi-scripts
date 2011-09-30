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
my $c = $q->get_config;

plan skip_all =>
  "URL required for testing, use ':: --url URL' or ('--json-file FILE')"
  unless $c->{url}
    or $c->{json_file};    # --url or --json-file (read URL from json)

my $e;
my $u = $c->{url};
if (!$u)
{
  $e = $q->read_json($c->{json_file});
  plan skip_all =>
    "URL required, JSON did not contain 'page_url', use --url URL"
    unless $e->{page_url};
  $u = $e->{page_url};
}

my $t = 1;
$t += 1 if $c->{json_file};
plan tests => $t;

my ($r, $o) = $q->run($u);
is($r, 0, "quvi exit status == 0")
  or diag $c->{url};
if ($c->{json_file})
{
SKIP:
  {
    skip 'quvi exit status != 0', 1 if $r != 0;
    my $f = $c->{json_file};
    my $j = $q->get_json_obj;
    cmp_deeply($j->decode($o), $e, "compare with $f")
      or diag $c->{url};
  }
}
