use fs qw(:all);
use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use Time::HiRes qw(usleep);

$lastdetect = 0;

my $ret = fs::ftrScanOpenDevice();
if($ret != 0)
{
	print "Couldn't open device!\n";
	exit(0);
}

$ret = fs::ftrScanGetOptions();
print "_Options: $ret\n";

# $ret = fs::ftrScanSetOptions(33);
print "Options: $ret\n";

my ($w,$h,$s) = fs::ftrScanGetImageSize();

print "W:$w,H:$h,S:$s\n";

my $detect;
$x = time;
my $i = 0;
while(($x + 10) > time)
{
	#if($i == 0) { fs::ftrScanSetDiodesStatus(0,255); print "0\n"; }
	$i++;
	#$detect = fs::ftrScanIsFingerPresent();
	$detect = fs::ftrScanGetFrame();
	print "L: " . length($detect) . "\n";
	if($detect > 0)
# 	if(length($detect) > 0)
	{
		$detect = fs::ftrScanGetBitmap();
		open(X, ">test.bmp");
		binmode(X);
		print X $detect;
		close(X);
		fs::ftrScanSetDiodesStatus(255,0);
		sleep(2);
		last;
	}
	#print "D: $detect\n";
	#if($detect == 1 && $lastdetect == 0) { fs::ftrScanSetDiodesStatus(255,0); print "1\n"; $lastdetect = 1; }
	#elsif($detect == 0 && $lastdetect == 1) { fs::ftrScanSetDiodesStatus(0,255); print "0\n"; $lastdetect = 0; }
	

 	usleep(500000);

}
#$ret = fs::ftrScanSetDiodesStatus(255,255);
#print "Ret: $ret\n";

$ret = fs::ftrScanSetDiodesStatus(0,0);

$serial = fs::ftrScanGetSerialNumber();

print "Serial: $serial\n";

fs::ftrScanCloseDevice();
print "Closed\n";

# fs::algorithminit();
# 
# fs::PutSecurityLevel9052vs9052(1);
# 
# fsinit();
# 
# my ($one,$two);
# 
# while(1)
# {
# 	fscheck();
# 	usleep(100000);
# 	if($newpic == 1 && length($one) == 0)
# 	{
# 		$one = $pictemplate;
# 		$newpic = 0;
# 		print "One collected\n";
# 	}
# 	elsif($newpic == 1)
# 	{
# 		$two = $pictemplate;
# 		print "Two collected\n";
# 		my $retval = fs::fpcompare($one,$two);
# 		print "Compare: $retval\n";
# 		undef($one);
# 		$newpic = 0;
# 	}
# }


# 
# sub fscheck
# {
# 	my ($r) = fs::OpenfsDevice();
# 	
# 	my $connected = fs::GetDeviceStatus();
# 	
# 	# Device was connected, but now it has been disconnected
# 	if($connected == 0 && $deviceconnected == 1)
# 	{
# 		lock($deviceconnected);
# 		$deviceconnected = 0;
# 		fs::ClosefsDevice();
# 		return(1);
# 	}
# 	# Device is still disconnected
# 	elsif($connected == 0 && $deviceconnected == 0) { return(1); }
# 	# Device was disconnected, but now it has been connected
# 	elsif($connected == 1 && $deviceconnected == 0)
# 	{
# 		my $r = fs::OpenfsDevice();
# 		if($r == 1)
# 		{
# 			lock($deviceconnected);
# 			$deviceconnected = 1;
# 		}
# 		return(1);
# 	}
# 	
# 	fs::OpenfsDevice();
# 	my $r = fs::fs_GetFingerDetectStatus();
#  	print "Status: $r\n";
# 	fs::ClosefsDevice();
# 	
# 	if($r > 0 && $livemode == 0 && time >= $fingersleep)
# 	{
# 		$fingertime = Time::HiRes::time;
# 		$livemode = 1;
# 	}
# # 	elsif($r == 1 && Time::HiRes::time - $fingertime > 1 && time >= $fingersleep)
# # 	{
# # 		fs::ChangeGain(250);
# # 	}
# 	elsif($r > 0 && $livemode == 1 && Time::HiRes::time - $fingertime > 1 && time >= $fingersleep)
# 	{
# 		$livemode = 0;
# 		$r = fs_saveimage();
# 	}
# 	# Finger no longer present
# 	elsif($r == 0)
# 	{
# 		$livemode = 0;
# 	}
# # 	elsif($r > 0 && Time::HiRes::time - $fingertime > 1)
# # 	{
# # 		$r = fs_saveimage();
# # 	}
# # 	
# # 	my $ready;
# # 	if($r == 2 || $r == 3 || $r == 4) { $ready = 1; }
# # 	else { $ready = 0; }
# # 	print "Ready: $ready,$r\n";
# # 	if($ready == 1 && time >= $fingersleep)
# # 	{
# # 		$r = fs_saveimage();
# # 	}
# 	return(1);
# }
# sub fs_saveimage
# {
# 	my ($r) = fs::OpenfsDevice();
# 	print "Extracting...\n";
# 	my ($basetemplate,$baseimage) = fs::fpextract_both();
# 	#fs::ClosefsDevice();
# 	
#  	print "L: " . length($baseimage) . "," . length($basetemplate) . "\n";
# 	
# 	$newpic = 1;
# 	$pic = $baseimage;
# 	$pictemplate = $basetemplate;
# 	$fingersleep = time + 3;
# }
# sub fsinit
# {
# 	my $r = fs::OpenfsDevice();
# 	if($r == 1)
# 	{
# 		lock($deviceconnected);
# 		$deviceconnected = 1;
# 	}
# 	return($r);
# }
