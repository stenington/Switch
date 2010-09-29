package ClockMock;

use Moose;
use DateTime;

extends 'Clock';

has 'frozen_time' => (
  is => 'rw',
  isa => 'DateTime',
  default => sub{ DateTime->now() },
);

sub time {
  my ($self) = @_;
  return $self->frozen_time;
}

sub add_minutes {
  my ($self, $inc) = @_;
  $self->frozen_time->add({ minutes => $inc });
}

no Moose;

__PACKAGE__->meta->make_immutable;
