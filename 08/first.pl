use strict;
use Data::Dumper;


my $max_i = 0;
my $max_j = 0;

my %antennas;

my $i = 0;
foreach my $line (<DATA>) {
    chomp $line;
    my $j = 0;
    foreach my $p (split //, $line) {
        if ($p =~ /[0-9]|[a-z]|[A-Z]/) {
            push @{$antennas{$p}}, [$i, $j];
        }
        $j += 1;
    }
    $i += 1;
    $max_j = $j-1 unless $max_j;
}
$max_i = $i-1;

my %antinodes;

foreach my $antenna (keys(%antennas)) {
    my $cords = $antennas{$antenna};
    for (my $k = 0; $k <= $#{$cords}; $k++) {
        for (my $l = 0; $l <= $#{$cords}; $l++) {
            next if ($k == $l);
            my $diff_i = $cords->[$l]->[0] - $cords->[$k]->[0];
            my $diff_j = $cords->[$l]->[1] - $cords->[$k]->[1];

            my $a1 = [$cords->[$k]->[0] - $diff_i, $cords->[$k]->[1] - $diff_j];
            my $a2 = [$cords->[$l]->[0] + $diff_i, $cords->[$l]->[1] + $diff_j];

            foreach my $a ($a1, $a2) {
                if (cordinates_valid($a->[0], $a->[1])) {
                    $antinodes{"$a->[0]x$a->[1]"} = undef;
                }
            }
        }
    }
}

print scalar(keys(%antinodes))."\n";

sub cordinates_valid($) {
    my $i = shift;
    my $j = shift;

    return 0 if $i < 0 || $i > $max_i;
    return 0 if $j < 0 || $j > $max_j;
    return 1;
}


__DATA__
..................................................
.r................................................
..........................I.......................
........................I.........................
................................................M.
............h......................A..............
..7....................I.........h................
......7..................................M....9...
.o.....U..........................................
......................................O...........
....c.................J................O...M...A..
..................................................
...R...7..........................................
..............r...................................
...................J..................9...........
...7..K......UJ...................................
......0...U.........................x.............
.......R.......0..B......................x........
.......................k.....Z.......9............
.......L.........I.....J............m.............
.....K.BR........r.0.C............................
.......K.BR......c................................
..................h....m....Al...........H........
..............L..k.......h...m..........x..9......
........................Z.....m........xO.........
..........0................l......................
.6..................b.............................
............k...o..............Z..................
........4.....o...........L.......................
....................Xo............................
...........8..B..L.........i......................
..z...............bX..........A...................
j........z...X......C.......i........5............
.b...H6.......................U.......l...........
..................X...............................
...6......................Z..........a............
....6........c............5.........1.............
.4.......................5........................
..........k.......H1l.............................
2.................C.......i...................u...
.............a....2...............................
.....z....H.......1..8.....................u......
...........j...b..................................
3.........j.........................a.............
...4................a.............................
..M................j.....1..........5.............
............................................u.....
..4..3...........i................................
z3.................2..............................
..........8..................2.C..................
