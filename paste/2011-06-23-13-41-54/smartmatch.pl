my $msg = 'The name "Maui" of the list element is already in use.';

my @warn = (
  qr/The name ".+" of the list element is already in use'/
 );


  
if ($msg ~~ @warn) {
  warn 'just a warning';
} else {
  die "Severe error" ;
}

