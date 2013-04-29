package Test::BangAway::Generator::Types::Enum;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(items)]);
use List::MoreUtils ();
use Test::BangAway::Generator::Object;

sub arbitrary {
    my $self = shift;
    elements @{$self->items};
}

sub coarbitrary {
    my ($self, $generator, $item) = @_;
    my $n = List::MoreUtils::first_index { $_ eq $item } @{$self->items};
    variant ($n, $generator);
}

1;
