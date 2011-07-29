use strict;
use warnings;


use Data::Dumper;
use File::Spec::Functions ':ALL';

use lib 'lib';

use Test;
use Local::DBIx::Simple;



my $file = test_db();
warn $file;
my $dbh  = create_ok(
	file    => catfile(qw{ basic.sql }),
	connect => [ "dbi:SQLite:$file" ],
);



my $Q = "SELECT * FROM table_one";

sub build_local {
    Local::DBIx::Simple->new( standard => 0 );
}

{    # CASE 1 - successful
    my $s   = build_local;
    my $dbs = DBIx::Simple->connect( $s->dbh );
    my $r   = $dbs->query($Q);
    warn sprintf 'Result of DBIx::Simple query: %s', Dumper($r);
    my $h = $r->hashes;
    warn sprintf 'Hashes? %s', Dumper($h);
}

{    # CASE 2 - successful
    my $s   = build_local;
    my $dbs = $s->dbs;
    my $r   = $dbs->query($Q);
    warn sprintf 'Result of DBIx::Simple-from-Local query: %s', Dumper($r);
    my $h = $r->hashes;
    warn sprintf 'Hashes? %s', Dumper($h);
}

{    # CASE 3 - *FAILS* when $self is quoted on line 165
    my $s = build_local;
    my $r = $s->dbs->query($Q);
    warn sprintf 'Result of Local::DBIx::Simple chained query (will fail until line 165 is fixed): %s', Dumper($r);

}


1;


