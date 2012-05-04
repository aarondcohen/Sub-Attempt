#!/usr/bin/env perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'Sub::Attempt' ) || print "Bail out!\n";
}

diag( "Testing Sub::Attempt $Sub::Attempt::VERSION, Perl $], $^X" );
