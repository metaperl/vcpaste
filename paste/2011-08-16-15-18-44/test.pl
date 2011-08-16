use Devel::SimpleTrace;

{

    package Util;

    sub dbconnect {
        use DBI;
        DBI->connect('dbi:SQLite:temp.db');
    }

}

{

    package Local::DBIx::Simple::Q;

    use Moo;

    has 'q' => ( is => 'rw', default => sub { $main::backgroundqueue } );
    has 'standard' => ( is => 'rw', default => 0 );

    use Data::Dumper;

    sub BUILD {
        my ($self) = @_;
        $main::globalstandardconnection = $self->standard

    }

    sub enq {
        my ( $self, @arg ) = @_;
        warn sprintf "Enqueing with id %d this data: %s", $self->enq_id,
          Dumper( \@arg );
        $self->q->enqueue( [ $self->enq_id, @arg ] );
    }

}

{

    package Local::DBIx::Simple;

    use Moo;
    extends qw(Local::DBIx::Simple::Q);

    use DBIx::Simple;

    has 'enq_id' => ( is => 'rw', default => 5 );
    has 'deq_id' => ( is => 'rw', default => 6 );

    sub dbh {

        Util::dbconnect;
    }

    sub dbs {
        my ($self) = @_;

        my $dbs = DBIx::Simple->connect( $self->dbh );
    }

}

{

    package main;

    use strict;
    use warnings;

    use Data::Dumper;
    use Test::More;

    use lib 'lib';

    sub constructor {
        Local::DBIx::Simple->new( standard => 0 );
    }

    sub create_database {
        my ($dbh) = @_;

        my $ddl = <<'EODDL';
create table table_one (
  col1 integer not null primary key,
  col2 TEXT
)
EODDL

        $dbh->do($ddl);
    }

    sub main {

        my $dbh = Util::dbconnect;
        create_database($dbh);

        my $Q = "SELECT * FROM table_one";

        my $desired_class = 'DBIx::Simple::Statement';
        my $desired_desc  = "object isa $desired_class";

        {    # CASE 1 - successful
            my $s   = constructor;
            my $dbs = DBIx::Simple->connect( $s->dbh );
            my $r   = $dbs->query($Q);

            warn sprintf 'Result of DBIx::Simple query: %s', Dumper($r);
            my $h = $r->hashes;
            warn sprintf 'Hashes? %s', Dumper($h);
            ok( $r->{st}->isa($desired_class), $desired_desc );
        }

        {    # CASE 2 - successful
            my $s   = constructor;
            my $dbs = $s->dbs;
            my $r   = $dbs->query($Q);
            warn sprintf 'Result of DBIx::Simple-from-Local query: %s',
              Dumper($r);
            my $h = $r->hashes;
            warn sprintf 'Hashes? %s', Dumper($h);
            ok( $r->{st}->isa($desired_class), $desired_desc );

        }

        {    # CASE 3 - *FAILS* when $self is quoted on line 165
            my $s = constructor;
            my $r = $s->dbs->query($Q);
            ok( $r->{st}->isa($desired_class), $desired_desc );

        }
    }
}

main() unless caller;

1;

