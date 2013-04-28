package Test::BangAway::CombinedMLCG;
use strict;
use warnings;
use constant M => [2147483563, 2147483399];
use constant A => [40014, 40692];
use constant Q => do {
    use integer;
    [map { M->[$_] / A->[$_] } 0 .. $#{M()}];
};
use constant R => do {
    use integer;
    [map { M->[$_] % A->[$_] } 0 .. $#{M()}];
};

sub new {
    my $class = shift;
    bless [@_] => $class;
}

sub next {
    my $self = shift;

    my $z = 0;
    for my $j (0 .. $#{M()}) {
        use integer;
        my $k = $self->[$j] / Q->[$j];
        $self->[$j] = A->[$j] * ($self->[$j] - $k * Q->[$j]) - $k * R->[$j];
        $self->[$j] += M->[$j] if $self->[$j] < 0;
        if ($j % 2 == 0) {
            $z += $self->[$j] - M->[0] + 1;
        } else {
            $z -= $self->[$j];
        }
        $z += M->[0] - 1 if $z < 1;
    }

    return $z;
}

sub next_rand {
    my $self = shift;
    $self->next / M->[0];
}

sub next_int {
    my $self = shift;
    my ($min, $max) = @_ == 2 ? @_ : (0, @_);
    ($min, $max) = ($max, $min) if $min > $max;
    int($self->next_rand * ($max - $min + 1)) + $min;
}

sub split {
    my $self = shift;

    my $other = (ref $self)->new(@$self);
    $other->next;

    for my $j (0 .. $#{M()}) {
        if ($j % 2 == 0) {
            if ($self->[$j] >= M->[$j] - 1) {
                $self->[$j] = 1;
            } else {
                $self->[$j] += 1;
            }
        } else {
            ($self->[$j], $other->[$j]) = ($other->[$j], $self->[$j]);
            if ($other->[$j] <= 1) {
                $other->[$j] = M->[$j] - 1;
            } else {
                $other->[$j] -= 1;
            }
        }
    }

    return $other;
}

1;
