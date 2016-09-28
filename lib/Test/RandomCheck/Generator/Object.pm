package Test::RandomCheck::Generator::Object;
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
        my ($rand, $size) = @_;
        $f->($self->pick($rand, $size))->pick($rand, $size);
    };
}

1;
