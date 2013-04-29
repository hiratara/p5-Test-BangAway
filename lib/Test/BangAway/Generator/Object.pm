package Test::BangAway::Generator::Object;
use strict;
use warnings;
use Exporter qw(import);
our @EXPORT = qw(
    gen const range elements variant
);

sub gen (&) {
    my $code = shift;
    bless $code => __PACKAGE__;
}

sub const (@) { my @args = @_; gen { @args } }

sub range ($$) {
    my ($min, $max) = @_;
    gen { $_[0]->next_int($min, $max) };
}

sub variant ($$) {
    my ($n, $generator) = @_;
    gen {
        use integer;
        my ($rand, $size) = @_;

        my ($i, $next_i, $cur_rand) = ($n, $n / 2, $rand);
        while ($i != $next_i) {
            my $another = $cur_rand->split;
            $cur_rand = $another if $i % 2 == 0;

            $i = $next_i;
            $next_i /= 2;
        }

        $generator->($cur_rand, $size);
    };
}

sub elements (@) {
    my $ref_elems = \@_;
    (range 0, $#$ref_elems)->map(sub { $ref_elems->[shift] });
}

sub pick {
    my ($self, $rand, $size) = @_;
    $self->($rand, $size);
}

sub map {
    my ($self, $f) = @_;
    gen { $f->($self->pick(@_)) };
}

sub flat_map {
    my ($self, $f) = @_;
    gen {
        my ($rand1, $size) = @_;
        my $rand2 = $rand1->split;
        $f->($self->pick($rand1, $size))->pick($rand2, $size);
    };
}

1;
