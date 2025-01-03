package AOC::2D::Map;
require AOC::2D::Field; import AOC::2D::Field;
use strict;

sub new {
    my $class = shift;
    my %opts  = @_;
    my $self = {
        map => [],
        max_i => 0,
        max_j => 0
    };

    bless $self, $class;
    return $self;
}

sub initialize($@) {
    my $self  = shift;
    my @input = @_;

    my $i = 0;
    foreach my $line (@input) {
        chomp $line;
        my $j = 0;
        $self->{map}->[$i] = [];
        foreach my $v (split //, $line) {
            $self->{map}->[$i]->[$j] = $v;
            $j += 1;
        }
        $i += 1;
        $self->{max_j} = $j-1 unless $self->{max_j};
    }
    $self->{max_i} = $i-1;
}

sub max_i($) {
    my $self = shift;
    return $self->{max_i};
}

sub max_j($) {
    my $self = shift;
    return $self->{max_j};
}

sub field($$$) {
    my $self = shift;
    my $i = shift;
    my $j = shift;

    return undef if $i < 0 || $i > $self->{max_i};
    return undef if $j < 0 || $j > $self->{max_j};
    if (exists($self->{map}->[$i]->[$j])) {
        return new AOC::2D::Field(i => $i, j => $j, value => $self->{map}->[$i]->[$j]);
    }
    return undef;
}

1;
