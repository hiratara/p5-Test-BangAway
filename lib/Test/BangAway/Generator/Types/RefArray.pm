package Test::BangAway::Generator::Types::ArrayRef;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max type)], rw => ['_inner_type']);
use Test::BangAway::Generator::Types::List;
use Test::BangAway::Generator::Types::Reference;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    my $list_type = list ($self->type, $self->min, $self->max);
    $self->_inner_type(Test::BangAway::Generator::Types::Reference->new(
        type => $list_type
    ));
    $self;
}

sub arbitrary {
    my $self = shift;
    $self->_inner_type->arbitrary;
}

sub coarbitrary {
    my $self = shift;
    $self->_inner_type->coarbitrary(@_);
}

1;
