package Locale::US;
BEGIN {
  $Locale::US::VERSION = '1.112140';
}

use 5.006001;
use strict;
use warnings;

use Data::Dumper;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Locale::US ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);




# Preloaded methods go here.

sub new {
    
    my $class = shift;
    my $self = {} ;

    seek( DATA, 0, 0 );

    while ( <DATA>) {
	chomp;
#	warn $_;
	last if /__END__/;
	my ($code, $state) = split ':';
	$self->{code2state}{$code}  = $state;
	$self->{state2code}{$state} = $code;
    }



#    warn Dumper $self;
    bless $self, $class;
}

sub all_state_codes {

    my $self = shift;

    keys % { $self->{code2state} } ;

}

sub all_state_names {

    my $self = shift;

    keys % { $self->{state2code} } ;

}

1;

__DATA__
AL:ALABAMA
AK:ALASKA
AS:AMERICAN SAMOA
AZ:ARIZONA
AR:ARKANSAS
CA:CALIFORNIA
CO:COLORADO
CT:CONNECTICUT
DE:DELAWARE
DC:DISTRICT OF COLUMBIA
FM:FEDERATED STATES OF MICRONESIA
FL:FLORIDA
GA:GEORGIA
GU:GUAM
HI:HAWAII
ID:IDAHO
IL:ILLINOIS
IN:INDIANA
IA:IOWA
KS:KANSAS
KY:KENTUCKY
LA:LOUISIANA
ME:MAINE
MH:MARSHALL ISLANDS
MD:MARYLAND
MA:MASSACHUSETTS
MI:MICHIGAN
MN:MINNESOTA
MS:MISSISSIPPI
MO:MISSOURI
MT:MONTANA
NE:NEBRASKA
NV:NEVADA
NH:NEW HAMPSHIRE
NJ:NEW JERSEY
NM:NEW MEXICO
NY:NEW YORK
NC:NORTH CAROLINA
ND:NORTH DAKOTA
MP:NORTHERN MARIANA ISLANDS
OH:OHIO
OK:OKLAHOMA
OR:OREGON
PW:PALAU
PA:PENNSYLVANIA
PR:PUERTO RICO
RI:RHODE ISLAND
SC:SOUTH CAROLINA
SD:SOUTH DAKOTA
TN:TENNESSEE
TX:TEXAS
UT:UTAH
VT:VERMONT
VI:VIRGIN ISLANDS
VA:VIRGINIA
WA:WASHINGTON
WV:WEST VIRGINIA
WI:WISCONSIN
WY:WYOMING
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Locale::US - two letter codes for state identification in the United States and vice versa.

=head1 SYNOPSIS

  use Locale::US;
 
  my $u = new Locale::US;

  my $state = $u->{code2state}{$code};
  my $code  = $u->{state2code}{$state};

  my @state = $u->all_state_names;
  my @code  = $u->all_state_codes;


=head1 ABSTRACT

Map from US two-letter codes to states and vice versa.

=head1 DESCRIPTION

=head2 MAPPING

=head3 $self->{code2state}

=head3 $self->{state2code}

=head2 DUMPING

=head3 $self->all_state_names

=head3 $self->all_state_codes


=head1 KNOWN BUGS AND LIMITATIONS

=over 4

=item * The state name is returned in C<uc()> format.

=item * neither hash is strict, though they should be.

=back

=head1 SEE ALSO


L<Locale::Country>

http://www.usps.gov/ncsc/lookups/usps_abbreviations.htm

    Online file with the USPS two-letter codes for the United States and its possessions.

=head1 AUXILIARY CODE:

    lynx -dump http://www.usps.gov/ncsc/lookups/usps_abbreviations.htm > kruft.txt
    kruft2codes.pl

=head1 COPYRIGHT INFO

Copyright: Copyright (c) 2002-2007 Terrence Brannon.  
All rights reserved.  This program is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.

License: GPL, Artistic, available in the Debian Linux Distribution at
/usr/share/common-licenses/{GPL,Artistic}


=head1 AUTHOR

T. M. Brannon, <tbone@cpan.org>

=head2 PATCHES

Thanks to stevet AT ibrinc for a patch about second call to new failing.

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by T. M. Brannon

=cut
