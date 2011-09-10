package Hello;

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

1;

