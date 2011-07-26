use fs;
use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use Time::HiRes qw(usleep);
use Verifier::Extractor;
use Verifier::Matcher;
use MIME::Base64;
use IO::Compress::Bzip2 qw(bzip2 $Bzip2Error);

Verifier::Extractor::fplicense();
Verifier::Matcher::fplicense();

my $ret = fs::ftrScanOpenDevice();
if($ret != 0)
{
	print "Couldn't open device!\n";
	exit(0);
}

my ($one,$two);

while(1)
{
	$detect = fs::ftrScanGetFrame();
	
	if($detect == 1 && length($one) == 0)
	{
		my $image = fs::ftrScanGetBitmap();
# 		my $compressed;
# 		bzip2 \$image => \$compressed or die print $Bzip2Error;
# 		my $encoded = encode_base64($image);
		
		$one = Verifier::Extractor::fpextract($image,length($image));
		print "One collected\n";
		fs::ftrScanSetDiodesStatus(255,0);
		sleep(2);
	}
	elsif($detect == 1)
	{
		my $image = fs::ftrScanGetBitmap();
# 		my $compressed;
# 		bzip2 \$image => \$compressed or die print $Bzip2Error;
# 		my $encoded = encode_base64($image);
		
		$two = Verifier::Extractor::fpextract($image,length($image));
		
		print "Two collected\n";
		my $score = Verifier::Matcher::fpmatch($one,length($one),$two,length($two));
		print "Compare: $score\n\n";
		undef($one);
		fs::ftrScanSetDiodesStatus(255,0);
		sleep(2);
	}
	usleep(100000);
}

