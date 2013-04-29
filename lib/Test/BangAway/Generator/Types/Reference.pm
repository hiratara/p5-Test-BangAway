package Test::BangAway::Generator::Types::Reference;
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
    my ($self, $generator, $array_ref) = @_;
    $self->type->coarbitrary($generator, @$array_ref);
}

1;
