use strict;
use Data::Dumper;

my $prune = 16777216;
my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my %sequences;

my $secret_sum = 0;
foreach my $initial (@input) {
    my $secret_node = {
        secret => $initial,
        last => 0,
        current_sequence => [],
        used_sequences => {},
    };
    $secret_sum += calculate($secret_node, 2000);
}

my $max_bananas = 0;
foreach my $sequence (keys %sequences) {
    my $current_bananas = 0;
    my $bananas = $sequences{$sequence};
    foreach my $b (@$bananas) {
        $current_bananas += $b;
    }
    print "$sequence: $current_bananas [" . join(",",@$bananas) . "] \n";
    $max_bananas = $current_bananas if $current_bananas >= $max_bananas;
}

print "Max bananas: $max_bananas\n";

sub calculate($$) {
    my $secret_node = shift;
    my $step = shift;

    my $given = $secret_node->{secret};
    if ($step > 0) {
        my $res1 = $given * 64;
        $res1 = ($res1 ^ $given) % $prune;

        my $res2 = int($res1 / 32);
        $res2 = ($res2 ^ $res1) % $prune;

        my $res3 = $res2 * 2048;
        $res3 = ($res3 ^ $res2) % $prune;

        $secret_node->{last} = $given;
        $secret_node->{secret} = $res3;

        my $price = substr($res3, -1);
        push @{$secret_node->{current_sequence}}, $price - substr($given, -1);
        if ($#{$secret_node->{current_sequence}} == 4) {
            shift @{$secret_node->{current_sequence}};
            my $k = join(",", @{$secret_node->{current_sequence}});
            if (! exists ($secret_node->{used_sequences}->{$k})) {
                if (! exists $sequences{$k}) {
                    $sequences{$k} = [];
                }
                push @{$sequences{$k}}, $price;
                $secret_node->{used_sequences}->{$k} = undef;
            }
        }
        return calculate($secret_node, $step - 1);
    }
    return $given;
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
