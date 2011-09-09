my $ml = 'c:/strawberry/perl/site/lib/Mojolicious';
my $a = "-a mojo";

use autodie qw(system);
for my $opts ( "-r -n -x -c -a mojo/lib;lib -a log" ) {
    my $out = "w";
    my $log = "log/$out.txt";
    my $cmd = "pp -v 99 -o $out.exe  webapp.pl  $opts  --log $log";
    print "$cmd\n";
    system $cmd;
}
