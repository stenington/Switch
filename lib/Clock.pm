package Clock;

use Moose;

sub time {
  my ($self) = @_;
  return DateTime->now();
}

no Moose;

__PACKAGE__->meta->make_immutable;
