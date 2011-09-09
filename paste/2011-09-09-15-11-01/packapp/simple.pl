#!/usr/bin/env perl

use autodie;
use autodie::exception;

warn "MOJO_HOME:$ENV{MOJO_HOME}/";

BEGIN {
  use FindBin;
  warn "BIN:$FindBin::Bin/";
}

BEGIN {
   if ($ENV{'PAR_TEMP'}) {
       my $dir = File::Spec->catfile ($ENV{'PAR_TEMP'}, 'inc');
       warn "dir:$dir/";
       push @INC, "$dir\lib";
       chdir 'mojo';  # yields Can't open file "Mojolicious\templates\exception.html.ep": No such file or directory at Mojolicious/Controller.pm line 24
       chdir "$dir\\mojo"; # yields Can't open file "Mojolicious\templates\exception.html.ep": No such file or directory at Mojolicious/Controller.pm line 24
       #chdir "$dir\\mojo\\lib"; # yields script: No such file or directory at Mojo/Home.pm line 28
       #chdir "$dir\\inc"; # yields Can't chdir('C:\Users\THEQUI~1\AppData\Local\Temp\par-thequietcenter\cache-9d9f36a0bf40430498d325a3e8d1fb5b163613f7\inc\inc'): No such file or directory at script/simple.pl line 28
       use Cwd;
       warn 'cwd' . getcwd;
   }
}

use Mojolicious::Lite;
use File::Spec;

get '/' => sub {
  my $self = shift;
  $self->render(text => 'Hello World!');
};

app->start('cgi');
