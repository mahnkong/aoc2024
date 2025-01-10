BEGIN {
    push @INC, "../lib";
}
use strict;
use Data::Dumper;
use AOC::Essentials;
use AOC::2D::Map;

my @input = AOC::Essentials::get_input(@ARGV ? "input.txt" : "example.txt");

my $map = new AOC::2D::Map(input => \@input, current_direction => 'N');
my $current_field = $map->find_first('^');
$current_field = $map->update($current_field, '.');

my %positions;
while (1) {
    $positions{$current_field->key()} = undef;
    my $next_field = $map->move($current_field);
    last unless $next_field;

    if ($next_field->value() eq "#") {
        $map->next_direction();
        next;
    }
    $current_field = $next_field;
};

print "Positions: " . scalar(keys(%positions))."\n";
