package ClockMock;

use Moose;
use DateTime;

extends 'Clock';

has 'time' => (
  is => 'rw',
  isa => 'DateTime',
  default => sub{ DateTime->now() },
);

sub add_minutes {
  my ($self, $inc) = @_;
  $self->time->add({ minutes => $inc });
}

no Moose;

__PACKAGE__->meta->make_immutable;
