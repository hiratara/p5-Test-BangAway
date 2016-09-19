package Test::RandomCheck::Generator::Types::Integer;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max)]);
use Test::RandomCheck::Generator::Object;

sub arbitrary {
    my $self = shift;
    range ($self->min, $self->max);
}

sub coarbitrary {
    my ($self, $generator, $n) = @_;
    variant ($n, $generator);
}

1;
