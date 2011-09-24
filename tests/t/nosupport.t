
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
my ($r) = $q->run("http://nosupport.url", "--support -qr 2>/dev/null");
is($r, 0x41, "quvi exit status == QUVI_NOSUPPORT");

foreach (@a)
{
  ($r) = $q->run($_, "--support -qr");
  is($r, 0x00, "quvi exit status == QUVI_OK");
}

# vim: set ts=2 sw=2 tw=72 expandtab:
