package Some::File;

use autodie qw/:all/;

sub hello {
    my $file = __FILE__;
    warn "My file name is $file. Here is my contents:";
    open(my $fh, "<", $file);
    my @data = <$fh>;
    warn "@data";
}

1;
