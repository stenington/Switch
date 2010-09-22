use strict;
use warnings;

use Test::More 'no_plan';
use_ok('App::Switch');
use ClockMock;

{
  my $app = new_ok('App::Switch');
}

{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(1);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:01", "one minute logged" );
}

{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(2);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:02", "two minutes logged" );
}

{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(10);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "00:10", "two minutes logged" );
}

{
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes(65);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "01:05", "an hour five minutes logged" );
}

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

{
  $DB::single=1;
  my $app = App::Switch->new();
  my $clock = ClockMock->new();
  $app->set_clock($clock);
  $app->switch_to("foo");
  $clock->add_minutes((24*60)+10);
  $app->switch_to("off");
  is( $app->get_time_for("foo", "today"), "24:10", "24:10 accumulated" );
}


