package Test::BangAway::Generator::Types::Product;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(types)]);
use Exporter qw(import);
use Test::BangAway::Generator::Types::AllInteger;
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

sub coarbitrary {
    my ($self, $generator, @xs) = @_;
    my $integer = Test::BangAway::Generator::Types::AllInteger->new;
    $integer->arbitrary->flat_map(sub {
        my $n = shift;
        my $new_generator = $self->types->[0]
                                 ->coarbitrary($generator, $xs[0]);
        for my $i (1 .. $#{$self->types}) {
            $new_generator = $self->types->[$i]
                                  ->coarbitrary($new_generator, $xs[$i]);
            $new_generator = variant ($n, $new_generator);
        }
        $new_generator;
    });
}

1;
