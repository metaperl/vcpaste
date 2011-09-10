use autodie qw/system/;

my $opts = '-P -r -n -x -c -Ilib';
my $out = "packed.pl";
my $cmd = "pp -P -x -c -v 99 --lib=lib -o $out  somefile.pl  $opts  --log $log";
print "$cmd\n";
system $cmd;

