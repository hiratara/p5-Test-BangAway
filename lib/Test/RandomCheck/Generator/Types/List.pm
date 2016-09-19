package Test::RandomCheck::Generator::Types::List;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(min max type)]);
use Exporter qw(import);
use Test::RandomCheck::Generator::Object;

our @EXPORT = qw(list);

sub list ($;$$) {
    my $type = shift;
    my ($min, $max) = @_;
    $min //= 0;
    $max //= 9;
    Test::RandomCheck::Generator::Types::List->new(
        type => $type, min => $min, max => $max
    );
}

sub arbitrary {
    my $self = shift;
    my ($min, $max) = ($self->min, $self->max);
    my $generator = $self->type->arbitrary;
    gen {
        my ($rand, $size) = @_;
        my $width = int (($max - $min) * $size / 100);
        $rand->next_int($min, $min + $width);
    }->flat_map(sub {
        my $n = shift;
        gen {
            my ($rand, $size) = @_;
            map { $generator->pick($rand->split, $size) } 1 .. $n;
        };
    });
}

sub coarbitrary {
    my ($self, $generator, @xs) = @_;
    $generator = variant (-1, $self->type->coarbitrary($generator, $_))
                                                                       for @xs;
    variant (0, $generator);
}

1;
