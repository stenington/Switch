package App::Switch;

use warnings;
use strict;

use DateTime;
use DateTime::Duration;
use Clock;

use Moose;

has 'clock' => (
  is => 'rw',
  writer => 'set_clock',
  isa => 'Clock',
  default => sub { Clock->new() },
);

has 'switch_time' => (
  is => 'rw',
  isa => 'DateTime',
);

has 'switch_name' => (
  is => 'rw',
  isa => 'Str',
  default => 'off',
);

has 'accum_times' => (
  is => 'rw',
  isa => 'HashRef[DateTime::Duration]',
  default => sub{ {}; },
);

sub switch_to {
  my ($self, $name) = @_;
  my $time = $self->clock->time;
  
  unless( $self->_currently_off() ) {
    $self->_accumulate_time($time);
  }
  $self->_record_switch($name, $time);
}

sub _currently_off {
  my ($self) = @_;
  return $self->switch_name eq "off";
}

sub _accumulate_time {
  my ($self, $time) = @_;
  my $switch_time = $self->switch_time;
  my $switch_name = $self->switch_name;
  $self->accum_times->{$switch_name} = DateTime::Duration->new() unless $self->accum_times->{$switch_name};
  $self->accum_times->{$switch_name}->add( $time->delta_ms($switch_time) );
}

sub _record_switch {
  my ($self, $name, $time) = @_;
  $self->switch_name( $name );
  $self->switch_time( $time->clone() );
}

sub get_time_for {
  my ($self, $name, $when) = @_;
  return sprintf("%02d:%02d", $self->accum_times->{$name}->in_units('hours', 'minutes'));
}

sub get_timecard_for {
  my ($self, $when) = @_;
  my $timecard = "Timecard for $when:\n";
  foreach my $name (keys %{$self->accum_times}) {
    $timecard .= "  $name: " . $self->get_time_for( $name, $when ) . "\n";
  }
  return $timecard;
}

no Moose;

__PACKAGE__->meta->make_immutable;
