BEGIN {
    push @INC, "../lib";
}

use strict;
use Data::Dumper;
use AOC::Essentials;
use AOC::2D::Map;
use feature 'signatures';

my @input = AOC::Essentials::get_input(@ARGV ? "input.txt" : "example.txt");

my $map = new AOC::2D::Map(input => \@input, current_direction => 'N');
my $first_field = $map->find_first('^');
my $current_field = $first_field->clone();

my %passed;

while (1) {
    $current_field = navigate_next($current_field, \%passed, 0);
    last unless $current_field;
}

my $obstacles = 0;
foreach my $obstacle (keys %passed) {
    my ($oi, $oj) = split /x/, $obstacle;
    my $test_field = $map->field($oi, $oj);
    if ($test_field->value() ne "^") {
        print "Testing $obstacle\n";
        $map->set_new_direction('N');
        $map->update($test_field, '#');

        my %visits;
        my $o_current_field = $first_field;
        my $abort = 0;
        do {
            if (exists($visits{$o_current_field->key() . "x" . $map->current_direction()})) {
                $obstacles += 1;
                $abort = 1;
            } else {
                $o_current_field = navigate_next($o_current_field, \%visits, 1);
            }
        } while (defined $o_current_field  && !$abort);
        $map->update($test_field, '.');
    }
}

print "Possible obstacles: $obstacles\n";

sub navigate_next($field, $visits_ref, $store_direction) {
    if ($store_direction) {
        add_visits($field, $visits_ref, $map->current_direction());
    } else {
        add_visits($field, $visits_ref, undef);
    }

    my $next_field = $map->move($field);
    return undef unless $next_field;

    if ($next_field->value() eq "#") {
        $map->next_direction();
    }

    my $new_field = $map->move($field);
    if ($new_field->value() ne '#') {
        $field = $new_field;
    }
    return $field;
}

sub add_visits($field, $visits, $direction) {
    if ($direction) {
        $visits->{$field->key()."x".$direction} = undef;
    } else {
        $visits->{$field->key()} = undef;
    }
}
