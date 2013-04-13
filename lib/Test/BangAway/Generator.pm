package Test::BangAway::Generator;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(
    gen const range elements list integer char string concat ref_hash ref_array
);

sub gen (&) {
    my $code = shift;
    bless $code => __PACKAGE__;
}

sub const (@) { my @args = @_; gen { @args } }

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
    my ($min, $max) = @_;
    (range $min // 0, $max // 9)->flat_map(sub {
        my $n = shift;
        gen { map { $generator->pick } 1 .. $n };
    });
}

sub integer () { range -100, 100 } # FIXME

sub char () { elements 'a' .. 'z', 'A' .. 'Z' }

sub string (;$$) {
    my ($min, $max) = @_;
    (list char, $min, $max)->map(sub {join '', @_});
}

sub concat (@) {
    my @generators = @_;
    gen { map { $_->pick } @generators };
}

sub ref_hash ($$;$$) {
    my ($key_generator, $value_generator, $item_min, $item_max) = @_;
   list(
       concat($key_generator, $value_generator), $item_min, $item_max
   )->map(sub { +{@_} });
}

sub ref_array ($;$$) {
    my ($generator, $min, $max) = @_;
    list($generator, $min, $max)->map(sub { [@_] });
}

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
