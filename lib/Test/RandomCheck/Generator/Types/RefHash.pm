package Test::RandomCheck::Generator::Types::HashRef;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (
    ro => [qw(min max key_type value_type)],
    rw => [qw(_list_type)],
);
use Test::RandomCheck::Generator::Types::List;
use Test::RandomCheck::Generator::Types::Reference;
use Test::RandomCheck::Generator::Types::Product;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my $kv = Test::RandomCheck::Generator::Types::Reference->new(
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

sub memoize_key {
    my ($self, $hash_ref) = @_;
    $self->_list_type->memoize_key(
        map { [$_ => $hash_ref->{$_}] } keys %$hash_ref
    );
}

1;
