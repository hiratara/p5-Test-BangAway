package Test::RandomCheck::Generator::Types::Product;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(types)]);
use Exporter qw(import);
use Test::RandomCheck::Generator::Types::AllInteger;
use Test::RandomCheck::Generator::Object;

our @EXPORT = qw(product);

sub product (@) {
    Test::RandomCheck::Generator::Types::Product->new(
        types => [@_]
    );
}

sub arbitrary {
    my $self = shift;
    gen {
        my ($rand, $size) = @_;
        map { $_->arbitrary->pick($rand, $size) } @{$self->types};
    };
}

sub memoize_key {
    my ($self, @xs) = @_;

    my @keys;
    for my $i (1 .. $#{$self->types}) {
        push @keys, $self->types->[$i]->memoize_key($xs[$i]);
    }

    join '\0', @keys;
}

1;
