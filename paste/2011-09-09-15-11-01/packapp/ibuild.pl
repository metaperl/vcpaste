my $ml = 'c:/strawberry/perl/site/lib/Mojolicious';
my $a = "-a mojo";

use autodie qw(system);
for my $opts ( "-r -n -x -c -a mojo -a log" ) {
    my $out = "simp";
    my $log = "log/$out.txt";
    my $cmd = "pp -v 99 -o $out.exe  simple.pl  $opts  --log $log";
    print "$cmd\n";
    system $cmd;
}
