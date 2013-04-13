package Test::BangAway;
use strict;
use warnings;
use Exporter qw(import);
use Test::More ();
use 5.008_005;
our $VERSION = '0.01';

our @EXPORT = qw(bang_away_ok);

sub bang_away_ok (&$;@) {
    my $code = shift;
    my $generator = shift;
    my %params = @_;
    my $shots = delete $params{shots} // 10000;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    for (1 .. $shots) {
        return Test::More::ok 0 unless $code->($generator->pick);
    }
    Test::More::ok 1;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::BangAway - Blah blah blah

=head1 SYNOPSIS

  use Test::BangAway;

=head1 DESCRIPTION

Test::BangAway is

=head1 AUTHOR

Masahiro Honma E<lt>hira.tara@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Masahiro Honma

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
