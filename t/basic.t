use strict;
use Test::More;
use Test::Builder::Tester;
use Test::BangAway;

sub prop_mytest1 { 1 }
sub prop_mytest2 { $_[0] == 10 ? 0 : 1 }

test_out "ok 1";
bang_away_ok \&prop_mytest1, ints;
test_test "just bang away";

test_out "not ok 1";
test_fail(+1);
bang_away_ok \&prop_mytest2, ints;
test_test "punch out the bug";

done_testing;
