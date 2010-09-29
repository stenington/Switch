use strict;
use warnings;

use Test::More 'no_plan';
use_ok('App::Switch');
use ClockMock;

# class is newable
{
  my $app = new_ok('App::Switch');
}

# switches one minute apart log one minute
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(1);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:01", "one minute logged" );
}

# switches two minutes apart log two minutes
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(2);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:02", "two minutes logged" );
}

# switches ten minutes apart log ten minutes
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(10);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:10", "ten minutes logged" );
}

# over sixty minutes logs as an hour
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(65);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "01:05", "an hour five minutes logged" );
}

# seperate sets of switches accumulate
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(1);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:01", "one minute accumulated" );
  $clock->add_minutes(1);
  $app->switch_to("foo");
  $clock->add_minutes(1);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:02", "two minutes accumulated" );
}

# hours accumulate
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(75);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "01:15", "1:15 accumulated" );
  $clock->add_minutes(10);
  $app->switch_to("foo");
  $clock->add_minutes(170);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "04:05", "4:05 accumulated" );
}

# days accumulate as hours
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes((24*60)+10);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "24:10", "24:10 accumulated" );
}

# multiple project accumulate separately
{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(1);
  $app->switch_to("bar");
  $clock->add_minutes(3);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:01", "foo time logged" );
  is( $app->get_time_for("bar", "today"), "00:03", "bar time logged" );
}


