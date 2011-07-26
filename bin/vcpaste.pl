use DateTime;

my $githubid = 'metaperl';
my $verbose  = 0;

sub datetimestamp {

  my $dt = DateTime->now;
  $dt->set_time_zone( 'America/New_York' );

  my $tmpnam = sprintf "%d-%02d-%02d-%02d-%02d-%02d",
    $dt->year, $dt->month, $dt->day,
      $dt->hour, $dt->minute, $dt->second;

}

# --------------------------------------------
# Get input file
# --------------------------------------------

my $file = shift;
use File::Basename;
my $basefile = basename($file);

# ---------------------------------------------------
# Make directory to copy input file to
# ---------------------------------------------------

my $newdir = datetimestamp;

use FindBin qw($Bin);

warn "$file, $basefile, $newdir, $Bin" if $verbose;

use Path::Class;
my @pastedir  = ($Bin, '..', 'paste', $newdir);
my $pastedir = dir(@pastedir);

warn $pastedir if $verbose;

use File::Path qw(make_path);

make_path($pastedir, { verbose => $verbose });

# --------------------------------------------
# Copy file to paste directory
# --------------------------------------------


use File::Copy;
use File::Copy::Recursive;

my $targetfile = file(@pastedir, $basefile);

if (-d $basefile) {
  dircopy($basefile, $targetfile);
  warn "dircopy($basefile, $targetfile);";
} else {
  copy($file, $targetfile);
}

# --------------------------------------------
# Add, commit, push new directory to github
# --------------------------------------------


use Git::Wrapper;

my $git = Git::Wrapper->new($Bin);

$git->add($pastedir);

$git->commit({ all => 1, message => "$file pasted by vcpaste" });

$git->push;

# --------------------------------------------
# Announce paste URL
# --------------------------------------------

my $pasteurl = "https://github.com/$githubid/vcpaste/blob/master/paste/$newdir/$basefile";

print "Paste available at $pasteurl\n";

require Clipboard;
Clipboard->import;
Clipboard->copy($pasteurl);

