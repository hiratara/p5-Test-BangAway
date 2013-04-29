package MyType;
use parent 'Test::BangAway::Generator::Types';
use Class::Accessor::Lite (rw => [qw(generator)]);
sub arbitrary { $_[0]->generator }

package main;
use strict;
use warnings;
use Test::BangAway;
use Test::BangAway::Generator::Object;
use Test::More;

bang_away_ok { @_ == 2 && $_[0] eq 'T' && $_[1] eq 'F' }
             MyType->new(generator => const qw(T F));
bang_away_ok { 10 <= $_[0] && $_[0] <= 20 }
             MyType->new(generator => range 10, 20);
bang_away_ok { $_[0] =~ /^[a-z]$/ }
             MyType->new(generator => elements 'a' .. 'z');

done_testing;
