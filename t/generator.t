use strict;
use warnings;
use Scalar::Util ();
use Test::BangAway;
use Test::BangAway::Generator;
use Test::More;

bang_away_ok { ! grep { $_ < 20 || 30 < $_  } @_ } list (integer 20, 30);
bang_away_ok { $_[0] =~ /^[a-zA-Z]$/ } char;
bang_away_ok { $_[0] =~ /^[a-zA-Z]{30,40}$/ } string 30, 40;
bang_away_ok {
    my ($string, @list) = @_;
    $string =~ /^[a-zA-Z]*$/ && ! grep { $_ < 1 || 5 < $_ } @list;
} concat +(string), (list (integer 1, 5));

bang_away_ok {
    my $hash = shift;
    ref $hash eq 'HASH' && ! grep { $_ < 50 || 60 < $_ } values %$hash;
} ref_hash string(10, 15), integer(50, 60), 5, 10;

bang_away_ok {
    my $array = shift;
    ref $array eq 'ARRAY' && ! grep { ! /^[a-z]$/ } @$array;
} ref_array(enum('a' .. 'z'), 5, 10);

bang_away_ok {
    my $data = shift;
    ref $data eq 'ARRAY' && ! grep { ! ref $_ eq 'HASH' } @$data;
} ref_array(
    ref_hash(
        string() => ref_array(enum qw(True False))
    ), 5, 10
);

bang_away_ok {
    my ($f, $x) = @_;
    Scalar::Util::looks_like_number($f->($x)) && $f->($x) == $f->($x);
} concat (function (integer, integer), integer);

bang_away_ok {
    my ($f, $x, $y) = @_;
    Scalar::Util::looks_like_number($f->($x)->($y))
                                           && $f->($x)->($y) == $f->($x)->($y);
} concat (function (integer, function (integer, integer)), integer, integer);

bang_away_ok {
    my ($f, @x) = @_;
    Scalar::Util::looks_like_number($f->(@x)) && $f->(@x) == $f->(@x);
} concat (function(list(integer), integer), list integer);

bang_away_ok {
    my ($f, $c) = @_;
    length $f->($c) == 1 && $f->($c) eq $f->($c);
} concat (function(char, char), char);

bang_away_ok {
    my ($f, $item) = @_;
    $f->($item) =~ /^[xyz]$/ && $f->($item) eq $f->($item);
} concat (function (enum (qw[a b c]), enum (qw[x y z])), enum (qw[a b c]));

bang_away_ok {
    my ($f, $n) = @_;
    length $f->($n) == 1 && $f->($n) eq $f->($n);
} concat (function (integer (10, 20), char), integer (10, 20));

my $type_int_char = concat (integer, char);
bang_away_ok {
    my ($f, $n, $c) = @_;
    Scalar::Util::looks_like_number($f->($n, $c))
                                               && $f->($n, $c) == $f->($n, $c);
} concat (function ($type_int_char, integer), $type_int_char);

my $type_int_char_enum = concat (integer, char, enum qw[True False]);
bang_away_ok {
    my ($f, $n, $c, $e) = @_;
    Scalar::Util::looks_like_number($f->($n, $c, $e))
                                       && $f->($n, $c, $e) == $f->($n, $c, $e);
} concat (function ($type_int_char_enum, integer), $type_int_char_enum);

bang_away_ok {
    my ($f, $ref_array) = @_;
    ref $f->($ref_array) eq 'HASH'
                                 && eq_hash $f->($ref_array), $f->($ref_array);
} concat (function (ref_array (char), ref_hash (char, char)), ref_array char);

bang_away_ok {
    my ($f, $str) = @_;
    Scalar::Util::looks_like_number($f->($str)) && $f->($str) == $f->($str);
} concat (function (string, integer), string);

bang_away_ok {
    my ($f, $ref_hash) = @_;
    ref $f->($ref_hash) eq 'ARRAY'
                                  && eq_array $f->($ref_hash), $f->($ref_hash);
} concat (function (ref_hash (char, char), ref_array (integer)),
                                                        ref_hash (char, char));

done_testing;
