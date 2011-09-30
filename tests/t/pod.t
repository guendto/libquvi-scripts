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

use Getopt::Long;
use Test::More;

eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;

my %config;
GetOptions(\%config, 'pod_dir|pod-dir|poddir|p=s@')
  or exit 1;

my @dirs = @{$config{pod_dir}} if $config{pod_dir};
plan skip_all => "Nothing to test" if scalar @dirs == 0;

all_pod_files_ok(all_pod_files(@dirs));

# vim: set ts=2 sw=2 tw=72 expandtab:
