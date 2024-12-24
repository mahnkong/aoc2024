use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

print Dumper @input;

sub get_input($) {
    my $file = shift;
    my @input;

    open my $fh, $file or die "Could not open $file: $!";
    while( my $line = <$fh>)  {
        chomp($line);
        push @input, $line;
    }
    close $fh;
    return @input;
}

sub cordinates_valid($$$$) {
    my $i = shift;
    my $j = shift;
    my $max_i = shift;
    my $max_j = shift;

    return 0 if $i < 0 || $i > $max_i;
    return 0 if $j < 0 || $j > $max_j;
    return 1;
}


sub coord_key($$) {
    my $i = shift;
    my $j = shift;
    return "${i}x${j}";
}

sub mark_field($$) {
    my $map = shift;
    my $coordinates = shift;
    my $value = shift;

    $map->[$coordinates->{i}]->[$coordinates->{j}] = $value;
}

sub field($$) {
    my $map = shift;
    my $coordinates = shift;

    return $map->[$coordinates->{i}]->[$coordinates->{j}];
}
