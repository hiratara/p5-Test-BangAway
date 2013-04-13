use strict;
use warnings;
use Test::BangAway;
use Test::BangAway::Generator;
use Test::More;

bang_away_ok { @_ == 2 && $_[0] eq 'T' && $_[1] eq 'F' } const qw(T F);
bang_away_ok { 10 <= $_[0] && $_[0] <= 20 } range 10, 20;
bang_away_ok { $_[0] =~ /^[a-z]$/ } elements 'a' .. 'z';
bang_away_ok { ! grep { $_ < 20 || 30 < $_  } @_ } list (range 20, 30);
bang_away_ok { $_[0] =~ /^[a-zA-Z]$/ } char;
bang_away_ok { $_[0] =~ /^[a-zA-Z]{30,40}$/ } string 30, 40;
bang_away_ok {
    my ($string, @list) = @_;
    $string =~ /^[a-zA-Z]*$/ && ! grep { $_ < 1 || 5 < $_ } @list;
} concat +(string), (list (range 1, 5));

bang_away_ok {
    my $hash = shift;
    ref $hash eq 'HASH' && ! grep { $_ < 50 || 60 < $_ } values %$hash;
} ref_hash string(10, 15), range(50, 60), 5, 10;

bang_away_ok {
    my $array = shift;
    ref $array eq 'ARRAY' && ! grep { ! /^[a-z]$/ } @$array;
} ref_array(elements('a' .. 'z'), 5, 10);

bang_away_ok {
    my $data = shift;
    ref $data eq 'ARRAY' && ! grep { ! ref $_ eq 'HASH' } @$data;
} ref_array(
    ref_hash(
        string() => ref_array(elements qw(True False))
    ), 5, 10
);

done_testing;
