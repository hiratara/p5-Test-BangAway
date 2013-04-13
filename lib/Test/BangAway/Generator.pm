package Test::BangAway::Generator;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(gen range elements list integer);

sub gen (&) {
    my $code = shift;
    bless $code => __PACKAGE__;
}

sub range ($$) {
    my ($min, $max) = @_;
    gen { int (rand ($max - $min + 1)) + $min };
}

sub elements (@) {
    my $ref_elems = \@_;
    (range 0, $#$ref_elems)->map(sub { $ref_elems->[shift] });
}

sub list ($;$$) {
    my $generator = shift;
    (range 0, 9)->flat_map(sub {
        my $n = shift;
        gen { map { $generator->pick } 1 .. $n };
    });
}

sub integer () { range -100, 100 } # FIXME

sub pick {
    my $self = shift;
    $self->();
}

sub map {
    my ($self, $f) = @_;
    gen { $f->($self->pick) };
}

sub flat_map {
    my ($self, $f) = @_;
    gen { $f->($self->pick)->pick };
}

1;
__END__
