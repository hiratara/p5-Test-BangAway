package Test::RandomCheck::Generator::Types::Char;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Exporter qw(import);
use Test::RandomCheck::Generator::Object;

our @EXPORT = qw(char);

sub char () { Test::RandomCheck::Generator::Types::Char->new }

sub arbitrary { elements 'a' .. 'z', 'A' .. 'Z' }

sub coarbitrary {
    my ($self, $generator, $c) = @_;
    variant (ord $c, $generator);
}

1;
