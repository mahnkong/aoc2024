use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my @towels;
my @designs;
foreach my $line (@input) {
    if ($line =~ /,/) {
        foreach my $t (split /, /, $line) {
            push @towels, $t;
        }
    } elsif ($line =~ /\S/) {
        push @designs, $line;
    }
}

my $regex = '^(' . join('|', @towels) . ')+$';
print $regex."\n";
my $designs_possible = 0;

foreach my $design (@designs) {
    print "Analysing Design: $design\n";
    $designs_possible += 1 if ($design =~ /$regex/);
}
print "Designs possible = $designs_possible\n";

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
