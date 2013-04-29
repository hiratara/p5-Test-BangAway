package Test::BangAway::Generator::Types::RefArray;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max type)], rw => ['_list_type']);
use Test::BangAway::Generator::Types::List;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->_list_type(list ($self->type, $self->min, $self->max));
    $self;
}

sub arbitrary {
    my $self = shift;
    $self->_list_type->arbitrary->map(sub { [@_] });
}

sub coarbitrary {
    my ($self, $generator, $ref_array) = @_;
    $self->_list_type->coarbitrary($generator, @$ref_array);
}

1;
