use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my $max_x = 100;
my $max_y = 102;

my @x_range;
for (my $i = 0; $i <= $max_x; $i++) {
    push @x_range, $i;
}
my @y_range;
for (my $j = 0; $j <= $max_y; $j++) {
    push @y_range, $j;
}

my @robots;

#@input = ("p=2,4 v=2,-3");

foreach my $input (@input) {
    if ($input =~ /p=([^,]+),([^ ]+) v=([^,]+),([^ ]+)/) {
        my $robot = {
            position => {
                x => $1,
                y => $2
            },
            velocity => {
                x => $3,
                y => $4
            }
        };
        push @robots, $robot;
    }
}

for (my $t = 0; $t < 100; $t++) {
    foreach my $robot (@robots) {
        move($robot);
    }
}

my %quadrants;
foreach my $robot (@robots) {
    my $quadrant = get_quadrant($robot);
    if ($quadrant) {
        $quadrants{$quadrant} += 1;
    }
}

my $safety_factor = 0;
foreach my $q (keys(%quadrants)) {
    if ($safety_factor) {
        $safety_factor *= $quadrants{$q};
    } else {
        $safety_factor = $quadrants{$q};
    }
}

print "Safety factor: $safety_factor\n";

sub get_quadrant($) {
    my $robot = shift;
    if ($robot->{position}->{x} < int($max_x / 2)) {
        if ($robot->{position}->{y}  < int($max_y / 2)) {
            return 1;
        } elsif ($robot->{position}->{y}  > int($max_y / 2)) {
            return 3;
        }
    } elsif ($robot->{position}->{x} > int($max_x / 2)) {
        if ($robot->{position}->{y}  < int($max_y / 2)) {
            return 2;
        } elsif ($robot->{position}->{y}  > int($max_y / 2)) {
            return 4;
        }
    }
    return 0;
}

sub move ($) {
    my $robot = shift;
    my $new_x = $robot->{position}->{x} + $robot->{velocity}->{x};
    my $new_y = $robot->{position}->{y} + $robot->{velocity}->{y};

    if ($new_x < 0) {
        $new_x = $x_range[$new_x];
    }
    if ($new_x > $max_x) {
        $new_x = $x_range[$new_x - $max_x - 1];
    }
    if ($new_y < 0) {
        $new_y = $y_range[$new_y];
    }
    if ($new_y > $max_y) {
        $new_y = $y_range[$new_y - $max_y - 1];
    }
    $robot->{position}->{x} = $new_x;
    $robot->{position}->{y} = $new_y;
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
