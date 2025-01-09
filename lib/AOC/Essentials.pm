package AOC::Essentials;

use feature 'signatures';
use strict;
use warnings;

sub get_input($file) {
    my @input;

    open my $fh, $file or die "Could not open $file: $!";
    while( my $line = <$fh>)  {
        chomp($line);
        push @input, $line;
    }
    close $fh;
    return @input;
}

1;
