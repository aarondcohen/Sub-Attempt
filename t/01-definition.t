#!/usr/bin/env perl

use Test::More tests => 11;

use strict;
use warnings;

use Sub::Attempt qw{:all};

#test scalar context forwarding
#test array context forwarding
#test that the number of attempts occurs
#test that success does not use the attempts

my $count = 0;
my $result;

attempt 0, sub { ++$count };
is $count, 0, "No attempts is a NOOP";

attempt 4, sub { ++$count };
is $count, 1, "Attempt returns on first success";

$count = 0;
$result = undef;
$result = attempt 4, sub { die "He was such a nice boy" unless $count++; 10 };
is $count, 2, "Failed at least 1 attempt";
is $result, 10, "Returned a result after at least 1 failure";

$count = 0;
$result = undef;
$result = attempt 4,
	sub { die "He was such a nice boy" unless $count++; 10 },
	sub { my $err = shift; $count += 0.1 if $err =~ /^He was such a nice boy\b/ };
is $count, 2.1, "Failed at least 1 attempt and was caught at least once";
is $result, 10, "Returned the result when called with an error handler";

do {
	local $@;

	$count = 0;
	$result = undef;
	eval { $result = attempt 4, sub { die "He was such a nice boy" if ++$count; 10 } };
	my $error = $@;
	is $count, 4, "Failed all attempts";
	like $error, qr{^He was such a nice boy\b}, "Error thrown after total failure";
	is $result, undef, "Result not set after all failures";
};

my $sresult = attempt 1, sub { time };
ok $sresult > 1000000000, "Attempt preserves scalar context";

my @aresult = attempt 1, sub { time };
ok scalar @aresult < 100, "Attempt preserves array context";


