BEGIN {
    push @INC, "../lib";
}
use strict;
use aoc::essentials;
use aoc::coordinates;

my @input = aoc::essentials::get_input(@ARGV ? "input.txt" : "example.txt");
print Dumper \@input;
