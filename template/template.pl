BEGIN {
    push @INC, "../lib";
}
use strict;
use Data::Dumper;
use AOC::Essentials;

my @input = AOC::Essentials::get_input(@ARGV ? "input.txt" : "example.txt");
print Dumper \@input;
