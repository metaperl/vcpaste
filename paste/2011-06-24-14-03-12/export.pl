use strict;
use warnings;

use lib 'C:/Users/thequietcenter/prg/biotrackthc/trunk';

use Data::Dumper;

use Local::DBH;

my $dbh = Local::DBH->new;

use DBIx::Simple;

my $dbs = DBIx::Simple->connect(Local::DBH->new->dbh);

my $action = 'ItemInventoryAdd';

my %table = (
  VendorAdd   => 'vendors',
  CustomerAdd => 'customers',
  ItemSalesTaxAdd => 'taxcategories',
  ItemInventoryAdd => 'products'
 );

my $q=<<"EOSQL";
SELECT * FROM $table{$action}
EOSQL

if ($action eq 'ItemInventoryAdd') {
  $q=<<"EOSQL";
SELECT 
  name,AVG(pricein) as pricein,SUM(quantity) as quantity
FROM 
  inventory i INNER JOIN products p ON (i.productid=p.id) 
WHERE 
  p.deleted = 0
  AND
    name IS NOT NULL
GROUP BY
  name
ORDER BY
  name
EOSQL
}

my $class = do {
  my @pkg = qw( Local::Quickbooks::CustomerAdd
		Local::Quickbooks::VendorAdd
		XML::Quickbooks::ItemSalesTaxAdd
		Local::Quickbooks::ItemInventoryAdd
	     );
  my ($class) = grep(/$action/, @pkg);
  use Class::MOP;
  Class::MOP::load_class($class);
  $class;
};

warn $action, $class;

my $Operation = $class->new(warnrequest => 1, warnresponse => 1);

use feature 'switch';


my (@warnings, @fatals);
DBI->trace(1);
for my $row ($dbs->query($q)->hashes) {

warn $row;


  next if $row->{deleted} || not $row->{name} ;


  $row->{Name} = $row->{name};

  warn $row->{name};

  given($action) {

    when('ItemSalesTaxAdd') {

      my %opt =  (
	TaxVendorRef => {ListID => $row->{id}},
	TaxRate => 100 * $row->{rate}
       );
      continue ;
    }

    when('ItemInventoryAdd') {
      # Does product already exist?
      my $q = $Operation->gnew('ItemInventoryQuery');
warn $q;
      my $arg = { FullName => $row->{name}};
      warn "exists $row->{name} ?";
      next if ($q->exists($arg));
      warn 'adding';

      # If not, then setup hash for ItemInventoryAdd operation
      $row->{Name} = delete $row->{name};
      $row->{SalesPrice} = delete $row->{pricein};
      $row->{QuantityOnHand} = delete $row->{quantity};

      continue ;
    }

    default {
      #warn Dumper($Operation);
      $Operation->process($row);
    }

  }

  next if $Operation->responseok;

  my $msg = $Operation->responsemsg;

  my @warn = (
    qr/The name (.+) of the list element is already in use/
   );

  my @fatal = (
    qr/There was an error when saving a Items list/
   );

  if ($msg ~~ @warn) {
    push @warnings, $msg;
    next;
  } else {
    push @fatals, $msg;
  }

}

warn "Warnings: @warnings";
warn "Fatal: @fatals";
