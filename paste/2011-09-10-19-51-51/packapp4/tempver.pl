# use File::Temp qw/ tempfile tempdir /;
# my $dir = tempdir;
# warn $dir;

my $tempdir = 'c:/Users/thequietcenter/AppData/Local/Temp/par-thequietcenter/cache-3afe7b18c0834470ab4f0e5978aea93496a0d55e';
unshift @INC, $tempdir;

use Data::Dumper;

require Hello;
Hello::hello();

warn Dumper( \@INC, \%INC );
