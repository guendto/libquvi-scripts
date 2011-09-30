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
use Test::Quvi;

my $q = Test::Quvi->new;

plan skip_all => "TEST_SKIP rule"
  if $q->test_skip("mem");

my $c = $q->get_config;

plan skip_all =>
  'valgrind required for testing, specify with --valgrind-path'
  unless $c->{valgrind_path};

plan tests => 9;

# invalid option, make an exception to redirect to /dev/null),
# gengetopt produced code checks and exits if this error occurs.
my ($r) = $q->run_with_valgrind('--invalid', '2>/dev/null');
is($r, 0x1, "exit status == 0x1");

# --version
($r) = $q->run_with_valgrind('--version');
is($r, 0x0, "exit status == 0x0");    # 0x0 = QUVI_OK

# --help
($r) = $q->run_with_valgrind('--help');
is($r, 0x0, "exit status == 0x0");    # 0x0 = QUVI_OK

# --support
($r) = $q->run_with_valgrind('--support');
is($r, 0x0, "exit status == 0x0");    # 0x0 = QUVI_OK

# --support arg
($r) =
  $q->run_with_valgrind('http://vimeo.com/1485507', '--support -qr');
is($r, 0x0, "exit status == 0x0");

# fetch, parse, exit
($r) = $q->run_with_valgrind('http://vimeo.com/1485507', '-qr');
is($r, 0x0, "exit status == 0x0");

# fetch, parse, exec and exit
($r) = $q->run_with_valgrind('http://vimeo.com/1485507',
                             '-qr --exec "echo %t ; echo %u"');
is($r, 0x0, "exit status == 0x0");

# (fetch, parse) x 2, exit
($r) =
  $q->run_with_valgrind(
                        'http://vimeo.com/1485507',
                        'http://megavideo.com/?v=HJVPVMTV',
                        '-qr'
                       );
is($r, 0x0, "exit status == 0x0");

# (fetch, parse) x 2, exit
# NOTE: first fails intentionally
($r) =
  $q->run_with_valgrind(
                        'http://ww.vimeo.com/1485507',
                        'http://megavideo.com/?v=HJVPVMTV',
                        '-qr'
                       );
is($r, 0x0, "exit status == 0x0");

# vim: set ts=2 sw=2 tw=72 expandtab:
