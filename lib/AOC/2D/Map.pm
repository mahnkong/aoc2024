use strict;
use v5.38;
use experimental 'class';
use AOC::2D::Field;

class AOC::2D::Map {

    field $map = [];
    field $max_i = 0;
    field $max_j = 0;
    field $input :param;
    field $current_direction :param;
    field $directions = { 'N' => 'E', 'E' => 'S', 'S' => 'W', 'W' => 'N' };

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

    method move($field) {
        return undef unless ($field);
        my $next_i = $field->i();
        $next_i += 1 if $current_direction eq 'S';
        $next_i -= 1 if $current_direction eq 'N';
        my $next_j = $field->j();
        $next_j += 1 if $current_direction eq 'E';
        $next_j -= 1 if $current_direction eq 'W';
        my $new_field = $self->field($next_i, $next_j);
        if ($new_field) {
            print __PACKAGE__ . ": move to " . $new_field->dump()."\n";
        }
        return $new_field;
    }

    method field($i, $j) {
        return undef if $i < 0 || $i > $max_i;
        return undef if $j < 0 || $j > $max_j;
        if (exists($map->[$i]->[$j])) {
            return AOC::2D::Field->new(i => $i, j => $j, value => $map->[$i]->[$j]);
        }
        return undef;
    }

    method find_first($value) {
        for (my $i = 0; $i <= $max_i; $i ++) {
            for (my $j = 0; $j <= $max_j; $j ++) {
                if ($map->[$i]->[$j] eq $value) {
                    return $self->field($i, $j);
                }
            }
        }
        return undef;
    }

    method update($field, $value) {
        my $u_field = $self->field($field->i(), $field->j());
        if ($u_field) {
            $map->[$u_field->i()]->[$u_field->j()] = $value;
            return $self->field($field->i(), $field->j());
        }
        return undef;
    }

    method next_direction() {
        $current_direction = $directions->{$current_direction};
        print __PACKAGE__ . ": current_direction => $current_direction\n";
        return $current_direction;
    }

    method current_direction() {
        return $current_direction;
    }

    method set_new_direction($new_direction) {
        $current_direction = $new_direction;
    }
}

1;
