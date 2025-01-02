package aoc::coordinates;

our $map   = [];
our $max_i = 0;
our $max_j = 0;

sub cordinates_valid($) {
    my $coordinates = shift;

    return 0 if $coordinates->{i} < 0 || $coordinates->{i} > $max_i;
    return 0 if $coordinates->{j} < 0 || $coordinates->{j} > $max_j;
    return 1;
}


sub coord_key($) {
    my $coordinates = shift;
    return "$coordinates->{i}x$coordinates->{j}";
}

sub mark_field($$) {
    my $coordinates = shift;
    my $value = shift;

    $map->[$coordinates->{i}]->[$coordinates->{j}] = $value;
}

sub field($) {
    my $coordinates = shift;
    return $map->[$coordinates->{i}]->[$coordinates->{j}];
}

1;
