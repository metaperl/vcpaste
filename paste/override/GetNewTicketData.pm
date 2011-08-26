package Local::Quickbooks::GetNewTicketData;

use Moose::Role;

override 'getnew' => sub {
    my ($self) = @_;

    my @row = $self->dbs->query( $self->getnewsql )->hashes;
    my %row;
    my %customerid;
    for my $row (@row) {
        if ( $row->{amount} < 0 ) {
            $row->{amount}   *= -1;
            $row->{quantity} *= -1;
        }
        push @{ $row{ $row->{id} } }, $row;
        $customerid{ $row->{id} } = $row->{customer_listid};
    }
    my @ret = map {
        my %row = (
            CustomerRef  => { ListID => $customerid{$_} },
            transactions => $row{$_}
        );
        \%row;
    } ( keys %row );

    warn Dumper(
        'Original Data', \@row, 'Mapped Data', \%row,
        'Returned Data', \@ret
    );
    return wantarray ? @ret : \@ret;
};

1;
