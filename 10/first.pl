BEGIN {
    push @INC, "../lib";
}
use strict;
use AOC::Essentials;
use AOC::2D::Field;
use AOC::2D::Map;

my @input = AOC::Essentials::get_input(@ARGV ? "input.txt" : "example.txt");

my %trailheads;
my $map = new AOC::2D::Map(input => \@input);

for (my $i = 0; $i <= $map->max_i(); $i++) {
    for (my $j = 0; $j <= $map->max_j(); $j++) {
        my $field = $map->field($i, $j);

        if ($field->value() == 0) {
            $trailheads{$field->key()} = {};
            find_route($field, $trailheads{$field->key()});
        }
    }
}

my $trailhead_sum = 0;
for my $trailhead (keys %trailheads) {
    $trailhead_sum += scalar(keys(%{$trailheads{$trailhead}}));
}
print "Sum: $trailhead_sum\n";

sub find_route($$) {
    my $field = shift;
    my $current_trailhead = shift;

    if ($field->value() == 9 && !exists($current_trailhead->{$field->key()})) {
        $current_trailhead->{$field->key()} = undef;
        return;
    }
    foreach my $k ($field->i()-1, $field->i()+1) {
        my $new_field = $map->field($k, $field->j());
        if ($new_field && $new_field->value() == $field->value() + 1) {
            find_route($new_field, $current_trailhead);
        }
    }
    foreach my $k ($field->j()-1, $field->j()+1) {
        my $new_field = $map->field($field->i(), $k);
        if ($new_field && $new_field->value() == $field->value() + 1) {
            find_route($new_field, $current_trailhead);
        }
    }
}
