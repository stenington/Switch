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

has 'accum_times' => (
  is => 'rw',
  isa => 'HashRef[DateTime::Duration]',
  default => sub{ {}; },
);

sub switch_to {
  my ($self, $name) = @_;
  my $time = $self->clock->time;
  my $switch_time = $self->switch_time;
  my $switch_name = $self->switch_name;
  unless( $switch_name eq 'off' ) {
    $self->accum_times->{$switch_name} = DateTime::Duration->new() unless $self->accum_times->{$switch_name};
    $self->accum_times->{$switch_name}->add( $time->delta_ms($switch_time) );
  }
  $self->switch_name( $name );
  $self->switch_time( $time->clone() );
}

sub get_time_for {
  my ($self, $name, $when) = @_;
  return sprintf("%02d:%02d", $self->accum_times->{$name}->in_units('hours', 'minutes'));
}

no Moose;

__PACKAGE__->meta->make_immutable;
