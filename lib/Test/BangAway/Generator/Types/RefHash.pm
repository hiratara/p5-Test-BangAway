package Test::BangAway::Generator::Types::RefHash;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max key_type value_type)]);
use Test::BangAway::Generator::Types::List;
use Test::BangAway::Generator::Types::Product;

sub arbitrary {
    my $self = shift;
    list(
        product($self->key_type, $self->value_type), $self->min, $self->max
    )->arbitrary->map(sub { +{@_} });
}

1;
