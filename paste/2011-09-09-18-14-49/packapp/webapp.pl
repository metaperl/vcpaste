#!/usr/bin/env perl

use autodie;
use autodie::exception;

use File::Spec;

BEGIN { warn " === Execution Starting..."; }

BEGIN {
    use FindBin;
    warn "BIN:$FindBin::Bin/";
}


BEGIN {
    my @CD = ( 
      [], 
      ['mojo'], 
      [qw/mojo lib/], 
      ['inc'] 
     );
    if ( $ENV{'PAR_TEMP'} ) {
        my $par_temp = File::Spec->catfile( $ENV{'PAR_TEMP'}, 'inc' );
	chdir($par_temp);
    }
}

use Mojolicious::Lite;
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
