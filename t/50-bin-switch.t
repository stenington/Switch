#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

ok( !system("bin/switch"), "exits cleanly" );
