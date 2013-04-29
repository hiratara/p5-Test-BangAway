package Test::BangAway::Generator::Types::Function;
use strict;
use warnings;
use parent "Test::BangAway::Generator::Types";
use Class::Accessor::Lite (ro => [qw(dom cod)]);
use Test::BangAway::Generator::Object;

sub arbitrary {
    my $self = shift;
    my $generator = $self->cod->arbitrary;
    gen {
        my ($rand, $size) = @_;
        my $freezed = $rand->clone;
        sub {
            my @x = @_;
            my $fixed_generator = $self->dom->coarbitrary($generator, @x);
            $fixed_generator->pick($freezed->clone, $size);
        };
    };
}

sub coarbitrary {
    my ($self, $generator, $f) = @_;
    $self->dom->arbitrary->flat_map(sub {
        my @x = @_;
        $self->cod->coarbitrary($generator, $f->(@x));
    });
}

1;
