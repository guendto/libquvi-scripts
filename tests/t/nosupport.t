
use warnings;
use strict;

use Test::More;

eval "use JSON::XS";
plan skip_all => "JSON::XS required for testing" if $@;

eval "use Test::Deep";
plan skip_all => "Test::Deep required for testing" if $@;

plan tests => 2;

use Test::Quvi;

my $q = Test::Quvi->new;

plan skip_all => "TEST_SKIP rule"
  if $q->test_skip("nosupport");

# Make a note of the use of /dev/null
my ($r) = $q->run("http://nosupport.url", "--support -qr 2>/dev/null");
is($r, 0x41, "quvi exit status == QUVI_NOSUPPORT");

($r) = $q->run("http://youtu.be/9dgSa4wmMzk", "--support -qr");
is($r, 0x00, "quvi exit status == QUVI_OK");

# vim: set ts=2 sw=2 tw=72 expandtab:
