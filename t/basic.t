use strict;
use Test::More;
use Test::Builder::Tester;
use Test::BangAway;
use Test::BangAway::Generator;

test_out "ok 1";
bang_away_ok { 1 } integer;
test_test "just bang away";

test_out "not ok 1";
test_fail(+1);
bang_away_ok { $_[0] == 10 ? 0 : 1 } integer;
test_test "punch out the bug";

test_out "ok 1";
bang_away_ok { 0 } integer, shots => 0;
test_test "Don't shoot, spend peacefully.";

done_testing;
