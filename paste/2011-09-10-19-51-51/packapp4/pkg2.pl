use autodie qw/:all/;

use File::Spec;

for (@INC) {
    if ( !ref $_ && -d $_ && !File::Spec->file_name_is_absolute($_) ) {
        $_ = File::Spec->rel2abs($_);
    }
}


use Data::Dumper;

require Hello;

$INC{'Hello.pm'} = ';loaikdjfh;akjdfaf';

Hello::hello();

warn Dumper( \@INC, \%INC );

