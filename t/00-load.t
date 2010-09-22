#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Switch' ) || print "Bail out!
";
}

diag( "Testing App::Switch $App::Switch::VERSION, Perl $], $^X" );
