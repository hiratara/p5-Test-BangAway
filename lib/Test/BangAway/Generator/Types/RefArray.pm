package Test::BangAway::Generator::Types::RefArray;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(type)]);
use Test::BangAway::Generator::Types::List;

sub arbitrary {
    my $self = shift;
    $self->type->arbitrary->map(sub { [@_] });
}

sub coarbitrary {
    my ($self, $generator, $ref_array) = @_;
    $self->type->coarbitrary($generator, @$ref_array);
}

1;
