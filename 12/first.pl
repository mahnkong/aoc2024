use strict;
use Data::Dumper;

my %directions = (
    'N' => {
        get => sub ($$) {
            my $i = shift;
            my $j = shift;
            return $i-1,$j;
        },

    },
    'S' => {
        get => sub ($$) {
            my $i = shift;
            my $j = shift;
            return ($i+1,$j);
        },
    },
    'W' => {
        get => sub ($$) {
            my $i = shift;
            my $j = shift;
            return ($i,$j-1);
        },
    },
    'E' => {
        get => sub ($$) {
            my $i = shift;
            my $j = shift;
            return ($i,$j+1);
        },
    }
);

my $map;
my %regions;
my %seen_fields;
my %current_region;

my $max_i = 0;
my $max_j = 0;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");
for (my $i = 0; $i <= $#input; $i++) {
    my @parts = split //, $input[$i];
    push @$map, [ @parts ];
    $max_j = $#parts + 1 unless $max_j;
}
$max_i = $#input + 1;

my @regions;
my $price;

for (my $i = 0; $i <= $#{$map}; $i++) {
    for (my $j = 0; $j <= $#{$map->[$i]}; $j++) {

        my $region = $map->[$i]->[$j];
        my $region_obj = {
            region => $region,
            area => 0,
            perimeter => 0
        };
        navigate_region($i, $j, $region_obj, $region);
        if ($region_obj->{area} > 0) {
             push @regions, $region_obj;
        }
    }
}

foreach my $region (@regions) {
    $price += $region->{area} * $region->{perimeter};
}

print "Price: $price\n";

sub navigate_region($$$) {
    my $i = shift;
    my $j = shift;
    my $region_obj = shift;
    my $wanted_region = shift;

    return if exists($seen_fields{coord_key($i, $j)});
    $seen_fields{coord_key($i, $j)} = 1;

    my $region = $map->[$i]->[$j];
    return if $region ne $wanted_region;

    $region_obj->{area} += 1;
    foreach my $direction (keys %directions) {
        my @neighbor_field = $directions{$direction}->{get}->($i, $j);
        if (cordinates_valid(@neighbor_field[0], @neighbor_field[1], $max_i, $max_j)) {
            my $n_region = $map->[$neighbor_field[0]]->[$neighbor_field[1]];
            if ($n_region ne $region) {
                $region_obj->{perimeter} += 1;
            } else {
                navigate_region($neighbor_field[0], $neighbor_field[1], $region_obj, $wanted_region);
            }
        } else {
            $region_obj->{perimeter} += 1;
        }
    }
}

sub coord_key($$) {
    my $i = shift;
    my $j = shift;
    return "${i}x${j}";
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


