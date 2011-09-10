

use autodie qw(system);
for my $opts ( "-v 99 -P -r -n -x -c -a mojo/lib;lib -a log" ) {
    my $out = "w";
    my $log = "log/$out.txt";
    my $cmd = "pp $opts -o out.pl webapp.pl --log $log";
    print "$cmd\n";
    system $cmd;
}
