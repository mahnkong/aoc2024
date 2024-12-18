use strict;
use Data::Dumper;

my %directions = (
    '^' => {
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{i} -= 1;
            return $n;
        },

    },
    'v' => {
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{i} += 1;
            return $n;
        },
    },
    '<' => {
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{j} -= 1;
            return $n;
        },
    },
    '>' => {
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{j} += 1;
            return $n;
        },
    }
);

my $map;
my $movements;
my $max_i = -1;
my $max_j = 0;
my $current_coordinates;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");
for (my $i = 0; $i <= $#input; $i++) {
    if ($input[$i] =~ /^#/) {
        $max_i += 1;
        my @parts = split //, $input[$i];
        push @$map, [ @parts ];
        $max_j = $#parts unless $max_j;
        unless ($current_coordinates) {
            for (my $j = 0; $j <= $#parts; $j ++) {
                if ($parts[$j] eq "@") {
                    $current_coordinates->{i} = $i;
                    $current_coordinates->{j} = $j;
                }
            }
        }
    } elsif ($input[$i] =~ /\S+/) {
        $movements .= $input[$i];
    }
}

foreach my $movement (split //, $movements) {
    my $next = $directions{$movement}->{go}->($current_coordinates);
    my $field = field($map, $next);
    if ($field eq "#") {
        print "# at current coords: $current_coordinates->{i}:$current_coordinates->{j} [$movement]\n";
        next;
    }
    if ($field eq "O") {
        move_field($map, $next, $movement);
        $field = field($map, $next);
        if ($field eq "O") {
            print "O at current coords: $current_coordinates->{i}:$current_coordinates->{j} [$movement]\n";
            next;
        }
    }
    $current_coordinates = $next;
    print "Moved to current coords: $current_coordinates->{i}:$current_coordinates->{j} [$movement]\n";
}

my $gps_coords = 0;
for (my $i = 0; $i <= $#$map; $i++) {
    for (my $j = 0; $j <= $#{$map->[$i]}; $j++) {
        if (field($map, {i => $i, j => $j}) eq "O") {
            $gps_coords += (100*$i + $j);
        }
    }
}

print "GPS Coords: $gps_coords\n";

sub move_field($$$) {
    my $map = shift;
    my $coordinates = shift;
    my $movement = shift;

    my $next = $directions{$movement}->{go}->($coordinates);
    my $field = field($map, $next);
    if ($field eq "#") {
        return;
    }
    if ($field eq "O") {
        move_field($map, $next, $movement);
        $field = field($map, $next);
        if ($field eq "O") {
            return;
        }
    }
    mark_field($map, $next, "O");
    mark_field($map, $coordinates, ".");
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
