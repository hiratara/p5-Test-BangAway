package Test::BangAway::Generator;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(gen range ints);

sub gen (&) {
    my $code = shift;
    bless $code => __PACKAGE__;
}

sub range ($$) {
    my ($min, $max) = @_;
    gen { int (rand ($max - $min + 1)) + $min };
}

sub ints () { range -100, 100 } # FIXME

1;
__END__
