use strict;
use warnings;
use Moose;

use Data::Dumper;
use SQL::Interp qw(:all);

use lib 'c:/Users/thequietcenter/prg/dbix-cookbook/lib';

*DBIx::Array::do        = \&DBIx::Array::update;
*DBIx::Array::sqlfield  = \&DBIx::Array::sqlscalar;
*DBIx::Array::sqlcolumn = \&DBIx::Array::sqlarray;
*DBIx::Array::sqlrow    = \&DBIx::Array::sqlarray;

sub DBIx::Array::interp {
    my ( $da, @param ) = @_;
    $da->do( sql_interp(@param) );
}

sub DBIx::Array::sqlrowhash {
    my ( $da, @arg ) = @_;
    my @data = $da->sqlarrayhash(@arg);
    $data[0];
}

has 'abstract' => (
    is      => 'rw',
    default => sub {
        use SQL::Abstract::More;
        SQL::Abstract::More->new;
    }
);

has 'da' => (
    is      => 'rw',
    default => sub {
        use DBIx::Cookbook::DBH;
        my $dbh = DBIx::Cookbook::DBH->new;
        use DBIx::Array;
        my $da = DBIx::Array->new;
        $da->connect( $dbh->for_dbi );
        $da;
    }
);

sub interp {
    my ( $self, @arg ) = @_;
    require SQL::Interp;

    sql_interp(@arg);
}

sub dump {
    my ( $my, @arg ) = @_;
    warn Dumper(@arg);
}

sub main {
    my ($func) = @_;

    my $o = __PACKAGE__->new;

    warn "$o";

    use DBI;
    DBI->trace(1);

    $o->$func;

}

main::main(@ARGV) unless caller;

sub add_lang {
    my ($my) = @_;

    for ( 1 .. 10 ) {
        $my->da->do(
            $my->abstract->insert( language => { name => "language$_" } ) );
        warn $_;
    }
}

sub trim_lang {
    my ($my) = @_;

    for ( 1 .. 10 ) {
        my %where = ( language_id => { '>', 13 } );
        $my->da->do( $my->abstract->delete( language => \%where ) );
        warn $_;
    }
}

sub single_row_scalar {
    my ($my) = @_;

    my %where = ( language_id => 5 );
    my $val =
      $my->da->sqlscalar(
        $my->abstract->select( language => 'name', \%where ) );
    warn $val;

}

sub single_row_list {
    my ($my) = @_;

    my %where = ( film_id => 5 );
    my ( $title, $desc ) =
      $my->da->sqlarray(
        $my->abstract->select( film => [qw(title description)], \%where ) );
    warn "($title, $desc)";

}

# single column
sub single_column {
    my ($my) = @_;

    my @country =
      $my->da->sqlcolumn( $my->abstract->select( country => 'country' ) );
    warn Dumper( \@country );

}

sub single_row {
    my ($my) = @_;

    my @data = $my->da->sqlrow('SELECT * FROM city WHERE city_id = 4');
    warn Dumper( \@data );

}

sub single_row_hashref {
    my ($my) = @_;

    # my @data = $my->da->sqlarrayhash('SELECT * FROM city WHERE city_id = 4');
    # warn Dumper( \@data );

    my $data = $my->da->sqlrowhash('SELECT * FROM city WHERE city_id = 4');
    warn Dumper($data);

}

sub fetch_all_aref {
    my ($my) = @_;

    my %where = ( address_id => { '>', 600 } );
    my @data =
      $my->da->sqlarrayarray(
        $my->abstract->select( address => [qw(address district)], \%where ) );
    warn Dumper( \@data );

}

sub fetch_all_href {
    my ($my) = @_;

    my %where = ( address_id => { '>', 600 } );
    my @data =
      $my->da->sqlarrayhash(
        $my->abstract->select( address => [qw(address district)], \%where ) );
    warn Dumper( \@data );

}

sub interp_examples {
    my ($my) = @_;

    my %data = (
        title       => 'perl programming wars' . rand(23423),
        description => 'epic drama of perl scripting',
        language_id => 1
    );

    my ( $sql, @bind ) = sql_interp( 'INSERT INTO film', \%data );

    warn Dumper( $sql, \@bind );

    $my->interp( 'INSERT INTO film', \%data );
    $my->interp(
        'UPDATE staff SET',
        { first_name => 'Bob' },
        'WHERE', { last_name => 'Stephens' }
    );
    $my->interp( 'DELETE FROM language WHERE language_id >', \7 );

    my $district = 'Okayama';
    my @in       = qw(547 376);
    $my->da->do(
        $my->interp(
            "SELECT * FROM address WHERE district =", \$district,
            "AND city_id IN",                         \@in
        )
    );

    $my->da->do(
        $my->interp(
            "SELECT * FROM address WHERE",
            { district => $district, city_id => \@in }
        )
    );

}

sub sql_hash {
    my ($my) = @_;

    my $sql = "SELECT city_id, city FROM city LIMIT 5";

    # my @rows = $da->_sqlarrayarray( sql => $sql, param => [], name => 0 );

    # die Dumper( \@rows );

    my $hash = $my->da->sqlhash($sql);
    $my->dump($hash);

}

sub sql_array_array {
    my ($my) = @_;

    my $sql = "SELECT city_id, city FROM city LIMIT 5";

    my $data = $my->da->sqlarrayarray($sql);
    $my->dump($data);

}

sub sql_array_array_name {
    my ($my) = @_;

    my $sql = "SELECT city_id, city FROM city LIMIT 5";

    my $data = $my->da->sqlarrayarrayname($sql);
    $my->dump($data);

}

sub sql_cursor {
    my ( $da, $abstract ) = @_;

    warn "DA:$da:";

    my $sql = "SELECT city_id, city FROM city LIMIT 5";
    my $sth = $da->sqlcursor($sql);

    die Dumper( $sql, $sth );

    my $hash = $da->sqlhash($sql);
    warn Dumper($hash);
}

1;

