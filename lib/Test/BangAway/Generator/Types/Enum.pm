package Test::BangAway::Generator::Types::Enum;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(items)]);
use Test::BangAway::Generator::Object;

sub arbitrary {
    my $self = shift;
    elements @{$self->items};
}

1;
