use strict;
use Data::Dumper;

my $prune = 16777216;
my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my $secret_sum = 0;
foreach my $initial (@input) {
    $secret_sum += calculate($initial, 2000);
}

print "Secret sum: $secret_sum\n";

sub calculate($$) {
    my $given = shift;
    my $step = shift;

    if ($step > 0) {
        my $res1 = $given * 64;
        $res1 = ($res1 ^ $given) % $prune;

        my $res2 = int($res1 / 32);
        $res2 = ($res2 ^ $res1) % $prune;

        my $res3 = $res2 * 2048;
        $res3 = ($res3 ^ $res2) % $prune;

        return calculate($res3, $step - 1);
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
