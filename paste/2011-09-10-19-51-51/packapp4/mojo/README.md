With the latest Mojolicious from CPAN, if you create an executable for webapp.pl by running
pack.pl then Mojolicious::Controller will fail to find the template directory because it 
uses this code to do so:

```perl
my $T = File::Spec->catdir(File::Basename::dirname(__FILE__), 'templates');
```

Because PAR::Packer-based executables run out of a temp directory, the relative path
returned by `__FILE__` is not found.

Changing the line to

```perl
my $T = File::Spec->catdir(File::Basename::dirname($INC{'Mojolicious/Lite.pm'} || __FILE__), 'templates');
```

results in the binary version of webapp.pl running successfully.

