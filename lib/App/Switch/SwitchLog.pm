package App::Switch::SwitchLog;

use Moose;

has 'accum_times' => (
  is => 'rw',
  isa => 'HashRef[DateTime::Duration]',
  default => sub{ {}; },
);

sub add {
  my ($self, $duration, $name) = @_;
  $self->accum_times->{$name} = DateTime::Duration->new() unless $self->accum_times->{$name};
  $self->accum_times->{$name}->add( $duration );
}

sub time_for {
  my ($self, $name) = @_;
  return sprintf("%02d:%02d", $self->accum_times->{$name}->in_units('hours', 'minutes'));
}

sub project_names {
  my ($self) = @_;
  my @names = keys %{$self->accum_times};
  return \@names;
}

no Moose;

__PACKAGE__->meta->make_immutable;
