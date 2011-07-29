use strict;
use warnings;

use lib map "c:/Users/thequietcenter/prg/biotrackthc/trunk/$_", qw(. Local/lib);

use TJ;

warn 1.1;
main::setup;

warn 1.2;
main::pre_startup;

warn 1.3;
use Local::DBIx::Simple;

warn 1.4;
use Data::Dumper;

#main::pre_startup;

my $Q = "SELECT * FROM customers";
my $s = Local::DBIx::Simple->new( standard => 0 );

{    # CASE 1 - successful
    my $dbs = DBIx::Simple->connect( $s->dbh );
    my $r   = $dbs->query($Q);
    warn sprintf 'Result of DBIx::Simple query: %s', Dumper($r);
    my $h = $r->hashes;
    warn sprintf 'Hashes? %s', Dumper($h);
}

{    # CASE 2 - successful
    my $dbs = $s->dbs;
    my $r   = $dbs->query($Q);
    warn sprintf 'Result of DBIx::Simple-from-Local query: %s', Dumper($r);
    my $h = $r->hashes;
    warn sprintf 'Hashes? %s', Dumper($h);
}

{    # CASE 3 - *FAILS*
    my $s = Local::DBIx::Simple->new( standard => 0 );
    my $r = $s->dbs->query($Q);
    warn sprintf 'Result of Local::DBIx::Simple query: %s', Dumper($r);

    #my $h = $r->hashes;
    #warn sprintf 'Hashes? %s', Dumper($h);
}

{    # CASE 4 - fully remote
    my $d = $s->dbs;
    my $r = $s->query($Q);
    warn sprintf 'Result of remote query: %s', Dumper($r);
    warn $s, $d, $r;
    my $h = $r->hashes;
    warn Dumper($h);
}

1;

done_testing();
