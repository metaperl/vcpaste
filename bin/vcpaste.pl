use DateTime;

sub datetimestamp {

  my $dt = DateTime->now;
  $dt->set_time_zone( 'America/New_York' );

  my $tmpnam = sprintf "%d-%02d-%02d-%02d-%02d-%02d",
    $dt->year, $dt->month, $dt->day,
      $dt->hour, $dt->minute, $dt->second;

}

my $file = shift;
use File::Basename;
my $basefile = basename($file);

my $newdir = datetimestamp;

use FindBin qw($Bin);

warn "$file, $basefile, $newdir, $Bin";

use Path::Class;
my @pastedir  = ($Bin, '..', 'paste', $newdir);
my $pastedir = dir(@pastedir);

warn $pastedir;

use File::Path qw(make_path);

make_path($pastedir, { verbose => 1 });

use File::Copy;

my $targetfile = file(@pastedir, $basefile);

copy($file, $targetfile);


use Git::Wrapper;
