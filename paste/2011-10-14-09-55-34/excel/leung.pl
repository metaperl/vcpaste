use strict;

use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::SaveParser;

use Util;

# http://search.cpan.org/~jmcnamara/Spreadsheet-WriteExcel-2.37/lib/Spreadsheet/WriteExcel.pm#MODIFYING_AND_REWRITING_EXCEL_FILES
my $parser   = Spreadsheet::ParseExcel::SaveParser->new();
my $workbook = $parser->Parse('leung.xls');

my $worksheet = $workbook->worksheet(0);

tellme($worksheet);

$worksheet->AddCell( 200, 0, 'hi there' );

tellme($worksheet);

$workbook->SaveAs('leung_new.xls');

