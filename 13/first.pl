use strict;
use Data::Dumper;
use List::Util qw( min max );

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my @machines;
my %current_config;
foreach my $line (@input) {
    if ($line =~ /Button (\w): X([^,]+), Y([^,]+)/) {
        $current_config{$1} = {
            X => $2,
            Y => $3
        }
    }
    if ($line =~ /Prize: X=(\d+), Y=(\d+)/) {
        $current_config{prize} = {
            X => $1,
            Y => $2
        };
        push @machines, { %current_config };
    }
}

my $tokens;
foreach my $machine (@machines) {
    my @m_tokens;
    for (my $i = 0; $i <= 100; $i++) {
        for (my $j = 0; $j <= 100; $j++) {
            my $prizeX = $machine->{A}->{X} * $i + $machine->{B}->{X} * $j;
            my $prizeY = $machine->{A}->{Y} * $i + $machine->{B}->{Y} * $j;
            if ($machine->{prize}->{X} == $prizeX && $machine->{prize}->{Y} == $prizeY) {
                push @m_tokens, $i*3 + $j;
            }
        }
    }
    $tokens += min(@m_tokens) if $#m_tokens >= 0;
}

print "Tokens: $tokens\n";

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
