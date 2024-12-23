use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my %connections;
foreach my $line (@input) {
    my ($left, $right) = split /-/, $line;
    $connections{$left}->{$right} = undef;
    $connections{$right}->{$left} = undef;
}

my $sets_of_three = 0;
my %sets_of_three;
foreach my $pc (keys %connections) {
    foreach my $pc2 (keys %{$connections{$pc}}) {
        foreach my $pc3 (keys %{$connections{$pc2}}) {
            if (exists($connections{$pc3}->{$pc}) && ($pc =~ /^t/ || $pc2 =~ /^t/ || $pc3 =~ /^t/)) {
                $sets_of_three{join(",",sort($pc,$pc2,$pc3))} = undef;
            }
        }
    }
}

foreach my $set_of_three (keys %sets_of_three) {
    $sets_of_three += 1;
    print "Set of three: $set_of_three\n";
}

print "Sets of three: $sets_of_three\n";

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
