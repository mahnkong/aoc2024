use strict;
use v5.38;
use experimental 'class';
use AOC::2D::Field;

class AOC::2D::Map {

    field $map = [];
    field $max_i = 0;
    field $max_j = 0;
    field $input :param;

    ADJUST {
        my $i = 0;
        foreach my $line (@$input) {
            chomp $line;
            my $j = 0;
            $map->[$i] = [];
            foreach my $v (split //, $line) {
                $map->[$i]->[$j] = $v;
                $j += 1;
            }
            $i += 1;
            $max_j = $j-1 unless $max_j;
        }
        $max_i = $i-1;
    }

    method max_i() {
        return $max_i;
    }

    method max_j() {
        return $max_j;
    }

    method field($i, $j) {
        return undef if $i < 0 || $i > $max_i;
        return undef if $j < 0 || $j > $max_j;
        if (exists($map->[$i]->[$j])) {
            return AOC::2D::Field->new(i => $i, j => $j, value => $map->[$i]->[$j]);
        }
        return undef;
    }
}

1;
