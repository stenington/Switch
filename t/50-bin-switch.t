#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

# sanity check basic call
{
  ok( !system("bin/switch foo"), "exits cleanly" );
}

# data persists between calls
sub dontdofornow {
  unlink "./switch.dat";
  `bin/switch foo`;
  `bin/switch off`;
  my $lines = `bin/switch --timecard today`;
  like( $lines, qr/Timecard for today.*foo:/, "timecard contains foo" );
}

#
