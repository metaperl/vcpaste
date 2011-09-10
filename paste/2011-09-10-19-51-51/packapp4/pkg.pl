use autodie qw/:all/;

use File::Spec;

for (@INC) {
    if ( !ref $_ && -d $_ && !File::Spec->file_name_is_absolute($_) ) {
        $_ = File::Spec->rel2abs($_);
    }
}

use Data::Dumper;

require Hello;
Hello::hello();

warn Dumper( \@INC, \%INC );

