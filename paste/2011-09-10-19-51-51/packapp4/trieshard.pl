# works in plain perl
# fails with this PAR::Packer compilation line:
# pp -P -r -v 99 -o packed.pl  somefile.pl

use Data::Dumper;

#use File::Spec;
# BEGIN {
#     for (@INC) {
#         if ( !ref $_ && -d $_ && !File::Spec->file_name_is_absolute($_) ) {
#             $_ = File::Spec->rel2abs($_);
#         }
#     }
# }

sub hello {
    chdir '..';
    my $file = __FILE__;
    warn '<@INC>';
    warn $_ for @INC;
    warn '</@INC>';
    warn "My file name is $file. Here is my contents:";
    open( my $fh, "<", $file );
    my @data = <$fh>;
    warn "@data";
}

warn Dumper( \@INC, \%INC );
hello();

1;

