package Test::BangAway::Generator::Types::Product;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(types)]);
use Exporter qw(import);
use Test::BangAway::Generator::Object;

our @EXPORT = qw(product);

sub product (@) {
    Test::BangAway::Generator::Types::Product->new(
        types => [@_]
    );
}

sub arbitrary {
    my $self = shift;
    gen {
        my ($rand, $size) = @_;
        map { $_->arbitrary->pick($rand->split, $size) } @{$self->types};
    };
}

1;
