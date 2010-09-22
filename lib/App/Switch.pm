package App::Switch;

use warnings;
use strict;

use DateTime;
use DateTime::Duration;

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

has 'accum_time' => (
  is => 'rw',
  isa => 'DateTime::Duration',
  default => sub{ DateTime::Duration->new() },
);

sub switch_to {
  my ($self, $name) = @_;
  my $time = $self->clock->time;
  my $switch_time = $self->switch_time;
  if( $name eq 'off' ) {
    $self->accum_time->add( $time->subtract_datetime($switch_time) );
  }
  $self->switch_time( $time->clone() );
}

sub get_time_for {
  my ($self, $name, $when) = @_;
  return sprintf("%02d:%02d", $self->accum_time->hours, $self->accum_time->minutes);
}

no Moose;

__PACKAGE__->meta->make_immutable;
