package AOC::2D::Field;
use Carp;
use strict;

sub new {
    my $class = shift;
    my %opts  = @_;
    my $self = {};

    foreach my $k ("i", "j", "value") {
        croak "option '$k' must be provided!" unless exists $opts{$k};
        $self->{$k} = $opts{$k};
    };

    bless $self, $class;
    return $self;

}

sub i($) {
    my $self = shift;
    return $self->{i};
}

sub j($) {
    my $self = shift;
    return $self->{j};
}

sub set_coordinates($$$) {
   my $self = shift;
   my $i = shift;
   my $j = shift;
   $self->{i} = $i;
   $self->{j} = $i;
}

sub value($) {
    my $self = shift;
    return $self->{value};
}

sub key($) {
    my $self = shift;
    return "$self->{i}x$self->{j}";
}

1;


