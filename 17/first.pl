use strict;
use Data::Dumper;

my @input = get_input(@ARGV ? "input.txt" : "example.txt");

my $registers = {
    A => undef,
    B => undef,
    C => undef
};

my $combo_operant = {
    0 => sub { return 0; },
    1 => sub { return 1; },
    2 => sub { return 2; },
    3 => sub { return 3; },
    4 => sub { return int($registers->{A}); },
    5 => sub { return int($registers->{B}); },
    6 => sub { return int($registers->{C}); },
    7 => sub { return undef; }
};

my $instructions = {
    0 => \&adv,
    1 => \&bxl,
    2 => \&bst,
    3 => \&jnz,
    4 => \&bxc,
    5 => \&out,
    6 => \&bdv,
    7 => \&cdv
};

my $program;
my $output = [];

foreach my $line (@input) {
    if ($line =~ /Register (\w{1}): (\d+)$/) {
        $registers->{$1} = int($2);
    } elsif ($line =~ /Program: (.+)$/) {
        $program = $1;
    }
}

my @program = split /,/, $program;
my $instruction_pointer = 0;
while ($instruction_pointer < $#program) {

    my $oip = $instruction_pointer;
    my $instruction = $program[$instruction_pointer];
    my $operand = int($program[$instruction_pointer + 1]);

    $instructions->{$instruction}->($operand);

    if ($oip == $instruction_pointer) {
        $instruction_pointer += 2;
    }
}

print join (",", @$output)."\n";

sub adv($) {
    my $operand = get_operand(shift);
    $registers->{A} = $registers->{'A'} / (2 ** $operand);
}

sub bxl($) {
    my $operand = shift;
    $registers->{B} = int($registers->{B}) ^ int($operand);
}

sub bst($) {
    my $operand = get_operand(shift);
    $registers->{B} = int($operand % 8);
}

sub jnz($) {
    my $operand = shift;
    if (int($registers->{A}) != 0) {
        $instruction_pointer = $operand;
    }
}

sub bxc($) {
    my $operand = shift;
    $registers->{B} = int($registers->{B}) ^ int($registers->{C});
}

sub out($) {
    my $operand = get_operand(shift);
    push @$output, $operand % 8;
}

sub bdv($) {
    my $operand = get_operand(shift);
    $registers->{B} = $registers->{A} / (2 ** $operand);
}

sub cdv($) {
    my $operand = get_operand(shift);
    $registers->{C} = $registers->{A} / (2 ** $operand);
}

sub get_operand($) {
    my $operand = shift;
    return exists($combo_operant->{$operand}) ? $combo_operant->{$operand}->() : $operand;
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
