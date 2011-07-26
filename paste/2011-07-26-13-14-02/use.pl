package T;

use lib do {
  my $root = 'c:/Users/thequietcenter/prg/biotrackthc/trunk';
  $root, "$root/Local/lib"
};

use Moose;

use fake;

sub X {
  warn 'x';
  warn T::dbconnect;
}
  

1;

package main;

my $x = T->new;
$x->X;

1;
