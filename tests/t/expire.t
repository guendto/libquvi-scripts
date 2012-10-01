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

eval "use LWP::UserAgent";
plan skip_all => "LWP::UserAgent required for testing" if $@;

use Test::Quvi;

my $q = Test::Quvi->new;
plan skip_all => "FIXME"; # Both website/{arte,pluzz}.lua need to be fixed.
plan skip_all => "TEST_SKIP rule" if $q->test_skip("expire");

my $ua = new LWP::UserAgent;
$ua->env_proxy;

my %h = (
  "http://videos.arte.tv" => sub {
    my $qr = qr|<h2><a href="/(\w\w)/videos/(.*?)"|;
    my ($page) = @_;
    "http://videos.arte.tv/$1/videos/$2" if $page =~ /$qr/;
  },
  "http://www.pluzz.fr/" => sub {
    my ($page, $url) = @_;
    my $rx_href = qr|class=""\s+href="(.*?)"|i;
    my $rx_url  = qr|$url|;
    for my $c ($page =~ /$rx_href/g)
    {
      return $c if $c =~ /$rx_url/;
    }
  }
);

plan tests => scalar(keys %h) * 2;

foreach (keys %h)
{
  note "fetching $_ ...";
  my $r = $ua->request(HTTP::Request->new(GET => $_));
  is($r->is_success, 1, "request is success") or diag $r->status_line;
SKIP:
  {
    skip 'request failed', 1 unless $r->is_success;
    note "matching...";
    my $url = $h{$_}($r->decoded_content, $_);
  SKIP:
    {
      skip 'no match: url', 1 unless $url;
      note "querying media...";
      ($r) = $q->run($url, "-vq -e-r");
      is($r, 0x00, "quvi exit status == QUVI_OK")
        or diag $url;
    }
  }
}

# vim: set ts=2 sw=2 tw=72 expandtab:
