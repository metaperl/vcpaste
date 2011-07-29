use lib map "c:/Users/thequietcenter/prg/biotrackthc/trunk/$_", qw(. Local/lib);

#use Carp::Always;

use TJ;


warn 1.1;
main::setup;

warn 1.2;
main::pre_startup;

warn 1.3;
use Local::DBIx::Simple;

warn 1.4;
use Data::Dumper;



#main::pre_startup;

{
warn( '<sleep>');
 sleep 60;


  my $standard = $main::globalstandardconnection;
warn( "</sleep standard=$standard>");

  my $s = Local::DBIx::Simple->new (standard => $standard);
  warn $s;
  my $d = $s->dbs;



  my $r = $s->query("SELECT * FROM customers");
  warn $s, $d, $r;
  my $h = $r->hashes;
  warn Dumper($h);

}

1;

done_testing;
