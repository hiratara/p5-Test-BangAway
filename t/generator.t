use strict;
use warnings;
use Test::BangAway;
use Test::BangAway::Generator;
use Test::More;

bang_away_ok { 10 <= $_[0] && $_[0] <= 20 } range 10, 20;
bang_away_ok { $_[0] =~ /^[a-z]$/ } elements 'a' .. 'z';
bang_away_ok { ! grep { $_ < 20 || 30 < $_  } @_ } list (range 20, 30);

done_testing;
