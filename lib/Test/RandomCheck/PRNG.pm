package Test::RandomCheck::PRNG;
use strict;
use warnings;

sub new { $_[0] }

sub next_rand { rand() }

sub next_int {
    my $self = shift;
    my ($min, $max) = @_ == 2 ? @_ : (0, @_);
    ($min, $max) = ($max, $min) if $min > $max;
    int($self->next_rand * ($max - $min + 1)) + $min;
}

1;
