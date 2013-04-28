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
    gen { $_[0]->next_int($min, $max) };
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
        gen {
            my $rand = shift;
            map { $generator->pick($rand->split) } 1 .. $n;
        };
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
    gen {
        my $rand = shift;
        map { $_->pick($rand->split) } @generators;
    };
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
    my ($self, $rand) = @_;
    $self->($rand);
}

sub map {
    my ($self, $f) = @_;
    gen { $f->($self->pick(@_)) };
}

sub flat_map {
    my ($self, $f) = @_;
    gen {
        my $rand1 = shift;
        my $rand2 = $rand1->split;
        $f->($self->pick($rand1))->pick($rand2);
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::BangAway::Generator - Tools to build a generator of random values

=head1 SYNOPSIS

  use Test::BangAway::Generator;

  my $data_generator = ref_array(
      ref_hash(
          string() => ref_array(elements qw(True False))
      ), 5, 10
  );
  # This generator yields values like following:
  # {
  #     'YLkOEF' => ['True'],
  #     'TwpMygm' => ['False', 'False', 'False', 'True', 'False'],
  # }

=head1 DESCRIPTION

Test::BangAway::Generator is a combinator to build random value generators
used by L<Test::BangAway>.

=head1 COMBINATORS

=over 4

=item C<<gen { ... };>>

The most primitive constructor of this class. The block should return
any values randomly. The block will be called on list context.

=item C<<const 1, 2, 3;>>

A generator which always returns specified values.

=item C<<range 1, 6;>>

A generator which returns integer from min to max randomly.

=item C<<elements qw(true false);>>

A generator which returns an element randomly.

=item C<<list $gen, 3, 10;>>

A generator which returns a list of values by using specified $gen.
The generated list will have length from min(e.g. 3) to max(e.g. 10).

=item C<<integer;>>

=item C<<char;>>

=item C<<string 8, 12;>>

A generator which generates values of primitive types.

=item C<<concat $gen1, $gen2, $gen3;>>

A generator which generates a list of values.
The generated list has fixed length which is the # of generators.

=item C<<ref_hash $key_gen, $val_gen, 3, 5;>>

A generator which returns an hash-ref.
Keys are produced by $key_gen and values are produced by $val_gen;
$key_gen should return one string value. On the other hand, $value_gen should
return just one value, but the value doesn't have to be string.
Any types of values are O.K.

=item C<<ref_array $gen, 3, 5;>>

A generator which returns an array-ref of values by using specified $gen.
The generated array-ref will have length from min(e.g. 3) to max(e.g. 5).

=back

=head1 METHODS

=over 4

=item C<<my @random_values = $gen->pick;>>

Pick a set of values from this generator.

=item C<<$gen->map(sub { ...; return @values });>>

A functor to apply normal functions to a Generator instance.

=item C<<$gen->flat_map(sub { ...; return $new_gen });>>

A kleisli composition to apply kleisli allows to a Generator instance.

=back

=head1 SEE ALSO

L<Test::BangAway>

=head1 AUTHOR

Masahiro Honma E<lt>hiratara@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Masahiro Honma

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
