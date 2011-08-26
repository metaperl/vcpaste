package Local::Quickbooks;

# ABSTRACT: Base class for our local interface to XML::Quickbooks

use Math::Fraction;

use TJ;

use Moose;
extends qw(XML::Quickbooks);

has 'getnewsql' => (is => 'rw', lazy_build => 1);
has 'exportmode'  => ( is => 'rw' );
has 'recordi'     => ( is => 'rw' );
has 'recordcount' => ( is => 'rw' );
has 'progressbar' => ( is => 'rw' );
has 'manager_results' => (
    is      => 'rw',
    default => sub { use Data::MultiValuedHash; Data::MultiValuedHash->new }
);


sub getnew {
    my ($self) = @_;

    use DBI;
    DBI->trace(1);

    $self->dbs->query($self->getnewsql)->hashes;
}


1;
