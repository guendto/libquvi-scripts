
use warnings;
use strict;

use Test::More;

eval "use JSON::XS";
plan skip_all => "JSON::XS required for testing" if $@;

eval "use Test::Deep";
plan skip_all => "Test::Deep required for testing" if $@;

plan tests => 4;

use Test::Quvi;

my $q = Test::Quvi->new;

plan skip_all => "TEST_SKIP rule"
  if $q->test_skip("shortened");

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
