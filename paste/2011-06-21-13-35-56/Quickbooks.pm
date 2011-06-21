package XML::Quickbooks;
# ABSTRACT: XML::Toolkit classes for manipulating Quickbooks

use Moose;

has 'request' => (is => 'rw');
has 'response' => (is => 'rw');
has 'responsetree' => (is => 'rw', lazy_build => 1);
has 'responseerror' => (is => 'rw');
has 'tree' => (is => 'rw');

use Carp;

sub _build_responsetree {
     my($self)=@_;

     use XML::TreeBuilder;
     $self->tree(XML::TreeBuilder->new);
     $self->tree->parse($self->response);
     $self->tree;
}


sub responseok {
     my($self)=@_;

     my $s = 'statusMessage';
     #warn $self->responsetree;
     my $elem = $self->responsetree->look_down($s => qr/.+/);
     #warn $elem->as_HTML;
     my $status = $elem->attr($s);
     #warn "status message: $status";
     if ($status eq 'Status OK') {
	  1;
     } else {
	  $self->responseerror($status);
	  Carp::cluck($status);
	  0;
     }
	  
}

sub evaluate {
    my($self, $r)=@_;
    $self->response($r);
    $self->responseok;
}

sub DEMOLISH {
my($self)=@_;
$self->tree->delete if $self->tree;
}

=head1 SYNOPSIS

    ...

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 ACKNOWLEDGEMENTS

=head2 Matthew S. Trout

    [16:27] <mst> uh, perl always adds '.' to @INC
    [16:28] <mst> well, except when running setuid
    [16:28] <mst> this is how Module::Install's 'use inc::Module::Install' works

    [16:38] <mst> metaperl: just add the Test::More functions to your @EXPORT
    [16:38] <mst> presto fucking exporto :)

=head1 SEE ALSO

=for :list
* L<OSR|https://member.developer.intuit.com/qbSDK-current/Common/newOSR/index.html>
* L<SDK Reference|https://member.developer.intuit.com/qbSDK-Current/doc/html/wwhelp/wwhimpl/js/html/wwhelp.htm?context=QBSDKProGuide&topic=QBSDKProGuide2>
* L<SDK Index|https://ipp.developer.intuit.com/0085_QuickBooks_Windows_SDK/010_qb/0050_Documentation/Manuals>
* L<Intuit Forums|https://idnforums.intuit.com/categories.aspx?catid=7>
* L<Early sample code|http://www.devx.com/xml/Article/30482/1954>

=cut
1;
