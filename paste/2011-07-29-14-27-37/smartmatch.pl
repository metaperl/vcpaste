use strict;
use warnings;

my @a = qw(1 2 3 4 5);

warn 3 ~~ @a;
warn 11 ~~ @a;
warn 4 ~~ \@a;

