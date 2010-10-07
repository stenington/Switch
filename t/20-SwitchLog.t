#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use DateTime::Duration;
use_ok 'App::Switch::SwitchLog';

# add a chunk of work for a project
{
  my $log = App::Switch::SwitchLog->new();
  $log->add( new DateTime::Duration( minutes => 10 ), "foo" );
  is( $log->time_for( "foo" ), "00:10", "add inital" );
  $log->add( new DateTime::Duration( minutes => 10 ), "foo" );
  is( $log->time_for( "foo" ), "00:20", "add accumulates" );
}

# get all project names
{
  my $log = App::Switch::SwitchLog->new();
  $log->add( new DateTime::Duration( minutes => 10 ), "foo" );
  is_deeply($log->project_names, ["foo"], "one name");
  $log->add( new DateTime::Duration( minutes => 10 ), "bar" );
  is_deeply($log->project_names, ["bar", "foo"], "two names");
  $log->add( new DateTime::Duration( minutes => 10 ), "bar" );
}
