BEGIN {
    push @INC, "../lib";
}
use strict;
use aoc::essentials;
use aoc::coordinates;

my @input = aoc::essentials::get_input(@ARGV ? "input.txt" : "example.txt");

my $i = 0;
my %trailheads;

foreach my $line (@input) {
    chomp $line;
    my $j = 0;
    $aoc::coordinates::map->[$i] = [];
    foreach my $p (split //, $line) {
        $aoc::coordinates::map->[$i]->[$j] = $p;
        $j += 1;
    }
    $i += 1;
    $aoc::coordinates::max_j = $j-1 unless $aoc::coordinates::max_j;
}
$aoc::coordinates::max_i = $i-1;

for (my $i = 0; $i <= $#{$aoc::coordinates::map}; $i++) {
    for (my $j = 0; $j <= $#{$aoc::coordinates::map->[$i]}; $j++) {
        if ($aoc::coordinates::map->[$i]->[$j] == 0) {
            $trailheads{aoc::coordinates::coord_key({i => $i, j => $j})} = {};
            find_route($i, $j, $trailheads{aoc::coordinates::coord_key({i => $i, j => $j})});
        }
    }
}

my $trailhead_sum = 0;
for my $trailhead (keys %trailheads) {
    $trailhead_sum += scalar(keys(%{$trailheads{$trailhead}}));
}
print "Sum: $trailhead_sum\n";

sub find_route($$) {
    my $i = shift;
    my $j = shift;
    my $current_trailhead = shift;

    my $val = $aoc::coordinates::map->[$i]->[$j];
    if ($val == 9 && !exists($current_trailhead->{(aoc::coordinates::coord_key({i => $i, j => $j}))})) {
        $current_trailhead->{aoc::coordinates::coord_key({i => $i, j => $j})} = undef;
        return;
    }
    foreach my $k ($i-1, $i+1) {
        if (aoc::coordinates::cordinates_valid({i => $k, j => $j}) && $aoc::coordinates::map->[$k]->[$j] == $val + 1) {
            find_route($k, $j, $current_trailhead);
        }
    }
    foreach my $k ($j-1, $j+1) {
        if (aoc::coordinates::cordinates_valid({i => $i, j => $k}) && $aoc::coordinates::map->[$i]->[$k] == $val + 1) {
            find_route($i, $k, $current_trailhead);
        }
    }
}
