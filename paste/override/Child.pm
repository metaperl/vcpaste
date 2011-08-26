package Local::Quickbooks::InvoiceAdd;

use Data::Dumper;
use Data::Rmap qw(:all);
use DateTime;

use Moose;

extends qw(XML::Quickbooks::Writer::InvoiceAdd Local::Quickbooks);
with 'Local::Quickbooks::GetNewTicketData';


1;
