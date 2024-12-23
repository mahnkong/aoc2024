use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my %connections;
foreach my $line (@input) {
    my ($left, $right) = split /-/, $line;
    $connections{$left}->{$right} = undef;
    $connections{$right}->{$left} = undef;
}

my @biggest;
foreach my $pc (keys %connections) {
    my @connected = keys %{$connections{$pc}};
    my @set=($pc);

    foreach my $left (@connected) {
        my $connected = 0;
        foreach my $right (@connected) {
            next if ($left eq $right);
            if (! exists($connections{$left}->{$right})) {
                print "$right and $left are not connected\n";
            } else {
                $connected += 1;
                print "$right and $left are connected\n";
            }
        }
        push @set, $left if $connected == $#connected - 1;
    }
    @biggest = sort(@set) if $#set > $#biggest;
}

print "Password: ". join(",", @biggest) . "\n";

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
