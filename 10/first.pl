use strict;
use Data::Dumper;

my $map = [];
my $i = 0;
my $max_i = 0;
my $max_j = 0;
my %trailheads;

foreach my $line (<DATA>) {
    chomp $line;
    my $j = 0;
    $map->[$i] = [];
    foreach my $p (split //, $line) {
        $map->[$i]->[$j] = $p;
        $j += 1;
    }
    $i += 1;
    $max_j = $j-1 unless $max_j;
}
$max_i = $i-1;

for (my $i = 0; $i <= $#{$map}; $i++) {
    for (my $j = 0; $j <= $#{$map->[$i]}; $j++) {
        if ($map->[$i]->[$j] == 0) {
            $trailheads{get_key($i, $j)} = {};
            find_route($i, $j, $trailheads{get_key($i, $j)});
        }
    }
}

my $trailhead_sum = 0;
for my $trailhead (keys %trailheads) {
    $trailhead_sum += scalar(keys(%{$trailheads{$trailhead}}));
}
print "Sum: $trailhead_sum\n";

sub find_route($$) {
    my $i = shift;
    my $j = shift;
    my $current_trailhead = shift;

    my $val = $map->[$i]->[$j];
    if ($val == 9 && !exists($current_trailhead->{(get_key($i, $j))})) {
        $current_trailhead->{get_key($i, $j)} = undef;
        return;
    }
    foreach my $k ($i-1, $i+1) {
        if (cordinates_valid($k, $j) && $map->[$k]->[$j] == $val + 1) {
            find_route($k, $j, $current_trailhead);
        }
    }
    foreach my $k ($j-1, $j+1) {
        if (cordinates_valid($i, $k) && $map->[$i]->[$k] == $val + 1) {
            find_route($i, $k, $current_trailhead);
        }
    }
}

sub get_key($$) {
    my $i = shift;
    my $j = shift;
    return $i."x".$j;
}

sub cordinates_valid($$) {
    my $i = shift;
    my $j = shift;

    return 0 if $i < 0 || $i > $max_i;
    return 0 if $j < 0 || $j > $max_j;
    return 1;
}

__DATA__
3431014564567889856765432104561217856787834345650410767
4321023673078974323896901223650306945698981298701321898
5891134982100165010187878910765445034567820543432456734
6780147890121016978776965010896532121054210612549345321
5491056787630967869987654123987034910123341701678763430
2312349896549890154890123234569123871431259898569321541
1009456785656743213765012234678034565430968367878490651
3238543876871056902153212105765123470121875454965581740
0147612987962347810042309876894325989430960323784670891
1254101796651258923031498121256716788567871212693021892
2760189845640769854120567010343805697634543000542136763
9871456732239878765987632129452934314523652101239545654
8102320121148543651456783478761043203410789654318767650
9810112510098652100347894567898110112341898769101658941
8723203450567787621239998456987567543898101678102347632
7654310961421298692108783015823458672189012363210412345
8941201872330178787145654324310569789076543654789301256
2300312360545689656014345678210655690343218945689430987
1412543451986770145123212109198744521256707650176521230
0503694012876871234338905410012633230569876543287810321
7654789323905965129847654321710123145678107434496929454
8969876454914456056789878930891231010103298921345218765
9878705967823327643056767011765310121012367800234309454
3210214877012018034145654322654301234189456012125498723
4569823898901219123233458743543210945676788321054321610
2378778767432301012012769658652101876501699490167600501
1267129876541018723103818569785438987612588588998010432
0398034567898129654278903478694323986543437677650323234
5487603478987034563365412323456410076345321761541454143
6034512987656189879450343015667567125256780890132969056
7123432100141098508761261018798258934101298743210878765
8923521231232987612567876529680112343210129654323769876
9812340321201236903498985434543209852101234569834954301
6701054450120145812385890365434901769015101078015867232
5432365965034566703456581270125892378754098129126798103
1019879870103875410787610789816765498763137430934567874
2988218789212980325692101296700012187212346501887656985
3678305654310341236543062345341123098703256232796540176
4549456789423467877879871056732014567890107145601230234
0032966761294558906978787810847812346921298050129821965
1121879850387643216785696921956909855430386765434745874
2340960345465434105898585430341098760987438876125636434
3651451276576123434703450121252387721236589980030127123
8960301289789016521012445696761456872345670891234898034
7871210348058907897654332781890018965645671432105677645
6210143232167812898101221650170123454534982145694789876
4301250143456103763218760521985439210122173036783296765
5654367897876554654109654432676098341013054921042107654
8769016788985467891010123354342187657894567832030078503
9878323412832345672561034565223476678743698948121899812
6765467803421232983478743470110569569652107819238987601
5653456912980221012989856789029678454765432108747896542
1012321233470110103456765891098763243854549654656505632
2187410345561256714987654302187654132923458743215014701
7896509876456349876878963213456565001210567898304323892
