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

sub memoize_key {
    my ($self, $n) = @_;
    $n;
}

1;
