use strict;
use warnings;
use Test::BangAway;
use Test::BangAway::CombinedMLCG;
use Test::BangAway::Generator;
use Test::More;

my $mlcg = Test::BangAway::CombinedMLCG->new(1, 1);
is $mlcg->next, 2147482884;
is $mlcg->next, 2092764894;
my $mlcg2 = $mlcg->split;
is $mlcg->next, 1621839889;
is $mlcg2->next, 483997720;
is $mlcg->next, 1388091868;
is $mlcg2->next, 516017270;

bang_away_ok {
    my ($s1, $s2) = @_;
    my $mlcg1 = Test::BangAway::CombinedMLCG->new($s1, $s2);
    my $mlcg2 = Test::BangAway::CombinedMLCG->new($s1, $s2);
    $mlcg1->next == $mlcg2->next && $mlcg1->next == $mlcg2->next;
} concat(integer, integer);

bang_away_ok {
    my ($s1, $s2) = @_;
    my $mlcg1 = Test::BangAway::CombinedMLCG->new($s1 + 1, $s2);
    my $mlcg2 = Test::BangAway::CombinedMLCG->new($s1, $s2 + 1);
    $mlcg1->next != $mlcg2->next && $mlcg1->next != $mlcg2->next;
} concat(integer, integer);

bang_away_ok {
    my ($s1, $s2) = @_;
    my $mlcg1 = Test::BangAway::CombinedMLCG->new($s1, $s2);
    my $mlcg2 = $mlcg1->split;
    my $mlcg3 = Test::BangAway::CombinedMLCG->new($s1, $s2);
    my $mlcg4 = $mlcg3->split;
    $mlcg1->next == $mlcg3->next && $mlcg2->next == $mlcg4->next;
} concat(integer, integer);

bang_away_ok {
    my ($range1, $range2) = @_;
    my $mlcg = Test::BangAway::CombinedMLCG->new;
    my $n = $mlcg->next_int($range1, $range2);
    my ($min, $max) = $range1 < $range2 ? ($range1, $range2)
                                        : ($range2, $range1);
    $min <= $n && $n <= $max;
} concat(integer, integer);

done_testing;
