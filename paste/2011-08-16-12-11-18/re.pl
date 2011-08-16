our $str = "Hither, thither and yonder";  

sub try1 {
  ($str =~ /^.(.\S+)/) and warn $1
}

sub try2 {
  my @split = (split qr/\s+/, substr($str, 1));
  warn $split[0];
}

try1;
try2;
