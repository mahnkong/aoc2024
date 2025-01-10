use Carp;
use strict;
use v5.38;
use experimental 'class';

class AOC::2D::Field {
    field $i :param;
    field $j :param;
    field $value :param;

    method i() { return $i }

    method j() { return $j }

    method value() { return $value; }

    method key() { return "${i}x${j}"; }

    method set_coordinates($new_i, $new_j) {
       $i = $new_i;
       $j = $new_j;
    }

    method dump() {
        return __PACKAGE__ . ": {i => $i, j => $j, value => $value}"
    }

    method clone() {
        return $self->new(i => $i, j => $j, value => $value);
    }
}

1;


