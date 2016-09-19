package Test::RandomCheck::Generator::Types::String;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max)], rw => ['_list_type']);
use Test::RandomCheck::Generator::Types::List qw(list);
use Test::RandomCheck::Generator::Types::Char qw(char);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->_list_type(list (char, $self->min, $self->max));
    $self;
}

sub arbitrary {
    my $self = shift;
    $self->_list_type->arbitrary->map(sub {join '', @_});
}

sub coarbitrary {
    my ($self, $generator, $str) = @_;
    $self->_list_type->coarbitrary($generator, split //, $str);
}

1;
