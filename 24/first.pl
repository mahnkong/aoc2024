use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my %gate_types = (
    AND => \&gate_and,
    OR => \&gate_or,
    XOR => \&gate_xor
);
my %wires;
my @gates;

foreach my $line (@input) {
    if ($line =~ /^([^:]+): (\d{1})/) {
        $wires{$1} = $2;
    } elsif ($line =~ /^(\S+) (\S+) (\S+) -> (\S+)/) {
        my $gate = {
            left => $1,
            type => $2,
            right => $3,
            out => $4,
        };
        push @gates, $gate;
    }
}

while (1) {
    my $open_wires_exist = 0;
    foreach my $gate (@gates) {
        if (! exists($wires{$gate->{left}}) || ! exists($wires{$gate->{right}})) {
            $open_wires_exist = 1;
            next;
        }

        if (! exists($wires{$gate->{out}})) {
            print "> $gate->{left} $gate->{type} $gate->{right}: $gate->{out}\n";
            $wires{$gate->{out}} = $gate_types{$gate->{type}}->($gate->{left}, $gate->{right});
            print "< $wires{$gate->{out}}\n";
        }
    }
    last unless $open_wires_exist;
}

my $output;
foreach my $key (reverse(sort(keys(%wires)))) {
    next if $key !~ /^z/;
    $output .= "$wires{$key}";
}

print "Code: " . oct("0b" . $output) ."\n";

sub gate_and($$) {
    my $left = shift;
    my $right = shift;

    return ($wires{$left} && $wires{$right}) ? 1 : 0;
}

sub gate_or($$) {
    my $left = shift;
    my $right = shift;

    return ($wires{$left} || $wires{$right}) ? 1 : 0;
}

sub gate_xor($$) {
    my $left = shift;
    my $right = shift;

    return ($wires{$left} != $wires{$right}) ? 1 : 0;
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

