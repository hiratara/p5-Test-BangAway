package Test::BangAway::Generator::Types::RefHash;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (
    ro => [qw(min max key_type value_type)],
    rw => [qw(_list_type)],
);
use Test::BangAway::Generator::Types::List;
use Test::BangAway::Generator::Types::RefArray;
use Test::BangAway::Generator::Types::Product;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my $kv = Test::BangAway::Generator::Types::RefArray->new(
        type => product ($self->key_type, $self->value_type)
    );
    my $inner_type = list ($kv, $self->min, $self->max);
    $self->_list_type($inner_type);
    $self;
}

sub arbitrary {
    my $self = shift;
    $self->_list_type->arbitrary->map(sub { +{map { @$_ } @_} });
}

sub coarbitrary {
    my ($self, $generator, $ref_hash) = @_;
    $self->_list_type->coarbitrary(
        $generator, map { [$_ => $ref_hash->{$_}] } keys %$ref_hash
    );
}

1;
