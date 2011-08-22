package Local::Quickbooks::Gtk2;

use strict;
use warnings;

require Gtk2;
Gtk2->import;

use Data::Dumper;

#use Gtk2 '-init';
sub TRUE  { 1 }
sub FALSE { 0 }

use Local::Quickbooks;

use Local::Gtk2::Tips;

my @action =
  qw(CustomerAdd VendorAdd EmployeeAdd ItemDiscountAdd ItemInventoryAdd InvoiceAdd);
my %action = (
    CustomerAdd      => { label => 'Customers' },
    VendorAdd        => { label => 'Vendors' },
    EmployeeAdd      => { label => 'Employees' },
    ItemDiscountAdd  => { label => 'Discount' },
    ItemInventoryAdd => { label => 'Inventory' },
    InvoiceAdd       => { label => 'Transactions' }
);

sub manage_qbexport {

    my ( $widget, $textbuffer, $mode_choice ) = @_;

    # my $text = $mode_choice->get_text;
    # die "mode_choice: $mode_choice: $text";

    # try {
    #   use XML::Quickbooks::RequestProcessor;
    #   XML::Quickbooks::RequestProcessor->new->connection;
    # } catch {
    #   main::myerr($_, $widget);
    # };
    use Try::Tiny;

    try {

        for my $action (@action) {

            $action{$action}{operationobject}->manager;

            my $M = $action{$action}{operationobject}->manager_results;

            my @output = map { my @result = $M->fetch($_) } qw(warning fatal);
            my @text = map { "* $_" } @output;
            my $text = join "\n", @text;

            warn Dumper( 'WARNINGFATAL', \@output );

            $textbuffer->insert( $textbuffer->get_end_iter, "$text" );

        }
        $textbuffer->insert( $textbuffer->get_end_iter,
            "\n* Export complete.\n" );
    }
    catch {
        warn "<FATAL>$_</FATAL>";
        s/at C:.+$//;
        $textbuffer->insert( $textbuffer->get_end_iter, "\n* $_" );
        my $parent_window = main::findparentwindow($widget);
        main::myerr( $_, $parent_window );
    }

}

sub textarea {
    my $sw2 = Gtk2::ScrolledWindow->new( undef, undef );
    $sw2->set_border_width(0);
    $sw2->set_shadow_type('etched-out');
    $sw2->set_policy( 'automatic', 'automatic' );

    #make text display area###################################
    # Create a textbuffer to contain that string
    my $textbuffer = Gtk2::TextBuffer->new();

    # Create a textview using that textbuffer
    my $textview = Gtk2::TextView->new_with_buffer($textbuffer);
    $sw2->add($textview);

    ( $sw2, $textbuffer )

}

sub progress_area {
    my $lqb = Local::Quickbooks->new;

    my $table = Gtk2::Table->new( scalar @action, 2 );
    $table->set_col_spacings(5);
    my %hbox;
    my ( $row, $column ) = ( 0, 0 );
    for my $action (@action) {

        my $label = Gtk2::Label->new( $action{$action}{label} );

        $table->attach_defaults( $label, 0, 1, $row, 1 + $row );

        my $O = $action{$action}{operationobject} =
          $lqb->lqb( $action, warnrequest => 1, warnresponse => 1 );

        my @rows              = $O->getnew;
        my $amount_to_process = scalar @rows;    # int rand 10;
        $O->recordcount($amount_to_process);

        my $progressbar = Gtk2::ProgressBar->new;
        $progressbar->set_text( $amount_to_process . " pending" );
        $O->progressbar($progressbar);

        $table->attach_defaults( $progressbar, 1, 2, $row, 1 + $row );

        ++$row;
    }
    $table;

}

sub simple_button {
    my ( $text, $clickedarg ) = @_;
    my $b = Gtk2::Button->new($text);
    $b->signal_connect( clicked => @$clickedarg ) if $clickedarg;
    $b;
}

sub big_label {
    my ($label) = @_;
    my $lab2 = Gtk2::Label->new($label);
    $lab2->set_markup(1);
    $lab2->set_label("<span size='x-large' weight='bold'>$label</span>");
    Gtk2::Misc::set_alignment( $lab2, 0.5, 0.5 );
    $lab2;
}

sub mode_label {
    big_label('Export Mode');
}

sub mode_choice {
    my $entry = Gtk2::Entry->new;
}

sub exportables_label {
    my $lab2 = Gtk2::Label->new("Exportables");
    $lab2->set_markup(1);
    $lab2->set_label("<span size='x-large' weight='bold'>Exportables</span>");
    Gtk2::Misc::set_alignment( $lab2, 0.5, 0.5 );
    $lab2;
}

sub results_label {
    my $lab2 = Gtk2::Label->new("Results");
    $lab2->set_markup(1);
    $lab2->set_label("<span size='x-large' weight='bold'>Results</span>");
    Gtk2::Misc::set_alignment( $lab2, 0.5, 0.5 );
    $lab2;
}

sub render {

    my ( $notebook, $notebuffer ) = Local::Gtk2::Tips::tips2();
    my $text = <<'EOTEXT';
Here you can export data from BiotrackTHC to Quickbooks. 

You must have the Quickbooks company file open in Quickbooks before clicking Export
EOTEXT

    $notebuffer->insert( $notebuffer->get_end_iter, $text );

    my ( $textarea_base, $textarea_buffer ) = textarea;

    # Construct Elements into UI

    my $vbox1 = Gtk2::VBox->new;
    $vbox1->add(exportables_label);
    $vbox1->add(progress_area);
    $vbox1->add(mode_label);

    my $mode_choice = mode_choice;
    warn "mode: $mode_choice";
    $vbox1->add($mode_choice);

    my $export_button =
      simple_button( "Begin Export", [ \&manage_qbexport, $textarea_buffer ] );

    $vbox1->add($export_button);
    $vbox1->add(results_label);
    $vbox1->add($textarea_base);

    my $hbox = Gtk2::HBox->new;
    $hbox->pack_start_defaults($notebook);

    $hbox->pack_start_defaults($vbox1);

    my $dialog = Gtk2::Dialog->new(
        'Quickbooks Export',
        undef,
        [qw/modal destroy-with-parent no-separator/],
        'gtk-ok' => 'accept'
    );

    $dialog->set_default_response('accept');
    $dialog->set_border_width(10);
    $dialog->set_size_request( 600, 400 );

    #my $window = Gtk2::Window->new;
    #
    #

    #$window->set_title('Quickbooks Export');

    $dialog->vbox->add($hbox);

    $dialog->show_all;
    $dialog->run;
    $dialog->destroy;

}

1;
