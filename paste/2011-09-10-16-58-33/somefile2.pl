# works in plain perl
# fails with this PAR::Packer compilation line:
# pp -P -r -v 99 -o packed.pl  somefile.pl

sub hello {
  chdir '..';
    my $file = __FILE__;
    warn "My file name is $file. Here is my contents:";
    open(my $fh, "<", $file);
    my @data = <$fh>;
    warn "@data";
}

hello();

1;

