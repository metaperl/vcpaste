package T;

use lib do {
  my $root = 'c:/Users/thequietcenter/prg/biotrackthc/trunk';
  $root, "$root/Local/lib"
};

use Moose;
use strict; use warnings;
use fake;

sub X {
  warn 'x';
  warn T::dbconnect;
}


package main;

use strict;
use warnings;

my $x = T->new;
$x->X;

 use Data::Dumper; print Dumper \%INC; 

1;
