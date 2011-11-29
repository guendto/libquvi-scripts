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

eval "use Test::Deep";
plan skip_all => "Test::Deep required for testing" if $@;

use Test::Quvi;

my $q = Test::Quvi->new;

plan skip_all => "TEST_SKIP rule"
  if $q->test_skip("nosupport");

my @a = qw(
  http://youtu.be/3WSQH__H1XE
  http://youtu.be/watch?v=3WSQH__H1XE
  http://youtu.be/embed/3WSQH__H1XE
  http://youtu.be/v/3WSQH__H1XE
  http://youtu.be/e/3WSQH__H1XE
  http://youtube.com/watch?v=3WSQH__H1XE
  http://youtube.com/embed/3WSQH__H1XE
  http://jp.youtube.com/watch?v=3WSQH__H1XE
  http://jp.youtube-nocookie.com/e/3WSQH__H1XE
  http://jp.youtube.com/embed/3WSQH__H1XE
  );

plan tests => 1 + scalar @a;

# Make a note of the use of /dev/null
my ($r) = $q->run("http://nosupport.url", "--support -vq -e-r 2>/dev/null");
is($r, 0x41, "quvi exit status == QUVI_NOSUPPORT");

foreach (@a)
{
  ($r) = $q->run($_, "--support -vq -e-r");
  is($r, 0x00, "quvi exit status == QUVI_OK");
}

# vim: set ts=2 sw=2 tw=72 expandtab:
