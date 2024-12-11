use strict;
use Data::Dumper;

my $input;
foreach my $line (<DATA>) {
    chomp($line);
    $input .= $line;
}

my @stones = split(/ /, $input);

for (my $i = 0; $i < 25; $i++) {
    my @new_stones;
    for my $stone (@stones) {
        if ($stone == 0) {
            push @new_stones, 1;
            next;
        }
        my $l = length($stone);
        if ($l % 2 == 0) {
            push @new_stones, int(substr($stone, 0, $l/2));
            push @new_stones, int(substr($stone, $l/2, $l/2));
            next;
        }
        push @new_stones, $stone * 2024;
    }
    @stones = @new_stones;
}
print "Stones: " . ($#stones + 1) . "\n";

__DATA__
2 54 992917 5270417 2514 28561 0 990
