package Test::BangAway::Generator::Types::RefArray;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max type)]);
use Test::BangAway::Generator::Types::List;

sub arbitrary {
    my $self = shift;
    list($self->type, $self->min, $self->max)->arbitrary->map(sub { [@_] });
}

1;
