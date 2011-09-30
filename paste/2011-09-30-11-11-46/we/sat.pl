#!/usr/bin/perl -w

use strict;

use Smart::Comments;

use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::SaveParser;

# Open the template with SaveParser
my $parser   = new Spreadsheet::ParseExcel::SaveParser;
my $template = $parser->Parse('sat.xls');
warn "template:$template:";

my $sheet = 0;
my $workbook;

{
    # SaveAs generates a lot of harmless warnings about unset
    # Worksheet properties. You can ignore them if you wish.
    local $^W = 0;

    # Rewrite the file or save as a new file
    $workbook = $template->SaveAs('new.xls');
}

# Use Spreadsheet::WriteExcel methods
my $worksheet = $workbook->sheets(0);
my $row       = 7;
my $col       = 3;

# Get the format from the cell
my $format = $template->{Worksheet}[$sheet]->{Cells}[$row][$col]->{FormatNo};
$worksheet->write( $row, $col => 'some_originating_entity', $format );
