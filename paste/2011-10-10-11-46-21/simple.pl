use strict;
use warnings;

my $f = 'item_amount';
my $key = 'item_amount5';

if ($f =~ /$key/) {
  warn 'match';
}
