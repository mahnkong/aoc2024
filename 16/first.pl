use strict;
use Data::Dumper;

my %directions = (
    '^' => {
        next => ['^', '<', '>'],
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{i} -= 1;
            return $n;
        },

    },
    'v' => {
        next => ['v', '<', '>'],
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{i} += 1;
            return $n;
        },
    },
    '<' => {
        next => ['<', '^', 'v'],
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{j} -= 1;
            return $n;
        },
    },
    '>' => {
        next => ['>', '^', 'v'],
        go => sub ($) {
            my $c = shift;
            my $n = {%$c};
            $n->{j} += 1;
            return $n;
        },
    }
);

my @input = get_input(@ARGV ? "input.txt" : "example2.txt");
my $map;
my $direction = '>';
my $max_i = -1;
my $max_j = 0;
my $current_coordinates;

for (my $i = 0; $i <= $#input; $i++) {
    if ($input[$i] =~ /^#/) {
        $max_i += 1;
        my @parts = split //, $input[$i];
        push @$map, [ @parts ];
        $max_j = $#parts unless $max_j;
        unless ($current_coordinates) {
            for (my $j = 0; $j <= $#parts; $j ++) {
                if ($parts[$j] eq "S") {
                    $current_coordinates->{i} = $i;
                    $current_coordinates->{j} = $j;
                }
            }
        }
    }
}

my %visited;
my $route = {
    score => 0,
    done => 0,
    direction => $direction,
    coords => {%$current_coordinates}
};

my $cheapest = 0;

my @routes = ($route);

while ($#routes >= 0) {
    @routes = sort { $a->{score} <=> $b->{score} } @routes;
    print "Routes: $#routes\n";
    foreach (my $i = $#routes; $i >= 0; $i--) {
        if ($routes[$i]->{done}) {
            splice(@routes,$i,1);
            next;
        } else {
            navigate($routes[$i]);
        }
    }
}

sub navigate($) {
    my $route = shift;

    my $coords = $route->{coords};
    my $direction = $route->{direction};

    my $v = field($map, $coords);
    #print "$direction $coords->{i}, $coords->{j} $v\n";
    if ($v eq "#") {
        $route->{done} = 1;
        return;
    }
    if ($v eq "E") {
        $route->{done} = 1;
        $cheapest = $route->{score} if !$cheapest || $route->{score} < $cheapest;
        return;
    }
    if (exists($visited{coord_key($coords, $direction)}) && $route->{score} >= $visited{coord_key($coords, $direction)}) {
        $route->{done} = 1;
        return;
    }
    $visited{coord_key($coords, $direction)} = $route->{score};

    foreach my $nd (@{$directions{$direction}->{next}}) {
        my $next = $directions{$nd}->{go}->($coords);

        my $new_route = {%$route};
        $new_route->{done} = 0;
        $new_route->{score} += 1;
        $new_route->{score} += 1000 if $nd ne $direction;
        $new_route->{coords} = $next;
        $new_route->{direction} = $nd;
        push @routes, $new_route;
    }
}

print "Cheapest: $cheapest\n";

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
    my $c = shift;
    my $d = shift;
    return "$c->{i}x$c->{j}x$d";
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
