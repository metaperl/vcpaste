#!/usr/bin/env perl

use autodie;
use autodie::exception;

use File::Spec;

use Data::Dumper;


BEGIN {
    use FindBin;
    warn "BIN:$FindBin::Bin/";
}

BEGIN {
    my @CD = ( [], ['mojo'], [qw/mojo lib/], ['inc'] );
    if ( $ENV{'PAR_TEMP'} ) {
        my $par_temp = File::Spec->catfile( $ENV{'PAR_TEMP'}, 'inc' );
       # chdir($par_temp);
    }
}

BEGIN {
    for (@INC) {
        if ( !ref $_ && -d $_ && !File::Spec->file_name_is_absolute($_) ) {
	  #$_ = File::Spec->rel2abs($_);
#	    $_ =~ s{\\}{/}g;
        }
    }
}


BEGIN { require Mojolicious::Lite; Mojolicious::Lite->import; }
use File::Spec;

get '/' => sub {
    my $self = shift;
    $self->render( text => 'Hello World!' );
};

app->start('cgi');

# Mojolicious/Controller line 21
# https://github.com/kraih/mojo/blob/master/lib/Mojolicious/Controller.pm#L21
# my $T = File::Spec->catdir(File::Basename::dirname(__FILE__), 'templates');

# Mojo/Home line 28
# https://github.com/kraih/mojo/blob/master/lib/Mojo/Home.pm#L28
# my @parts = File::Spec->splitdir(abs_path $ENV{MOJO_HOME});
