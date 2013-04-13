use strict;
use Test::More;
use Test::Builder::Tester;
use Test::BangAway;

test_out "ok 1";
bang_away_ok { 1 } ints;
test_test "just bang away";

test_out "not ok 1";
test_fail(+1);
bang_away_ok { $_[0] == 10 ? 0 : 1 } ints;
test_test "punch out the bug";

done_testing;
