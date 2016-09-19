package Test::RandomCheck::Generator::Types::AllInteger;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Config ();
use Test::RandomCheck::Generator::Object;

sub arbitrary {
    gen {
        my ($rand, $size) = @_;
        return 0 if $size <= 0;

        my $bits = int (($Config::Config{ivsize} * 8 - 1) * $size / 100);
        my $n = 1 << $bits;
        $rand->next_int(- $n, $n - 1);
    };
}

sub coarbitrary {
    my ($self, $generator, $n) = @_;
    variant $n, $generator;
}

1;
