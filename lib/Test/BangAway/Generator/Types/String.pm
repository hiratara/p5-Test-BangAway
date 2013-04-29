package Test::BangAway::Generator::Types::String;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max)]);
use Test::BangAway::Generator::Types::List qw(list);
use Test::BangAway::Generator::Types::Char qw(char);

sub arbitrary {
    my $self = shift;
    list (char, $self->min, $self->max)->arbitrary->map(sub {join '', @_});
}

1;
