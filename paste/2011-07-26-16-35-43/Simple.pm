package Local::DBIx::Simple;

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Simple';

use TJ;

has 'q'      => ( is => 'rw', default => $main::backgroundqueue );
has 'enq_id' => ( is => 'rw', default => 5 );
has 'deq_id' => ( is => 'rw', default => 6 );

sub BUILD {
    my ($self) = @_;

}

override 'new' => \&mynew;

sub mynew {
  my($class)=@_;
  bless {}, $class;
}


sub dbh {
    # use Local::DBH;

    # my $dbh = Local::DBH->new->dbh;
    main::dbconnect();
}

sub dbs {
    my ($self) = @_;

    my $dbs = Local::DBIx::Simple->connect( $self->dbh );


}

sub enq {
  my($self,@arg)=@_;
  $self->q->enqueue( $self->enq_id, @arg );
}

override 'query' => \&threaded_query;

sub threaded_query {
    my ( $self, $query, @binds ) = @_;
    my ( $ref, $window, $progressbar, $timeout, $generror );

    return super() if ( $main::globalstandardconnection == 1 );

    $self->enq( $query, \@binds );

    if ( $main::globalprogressbarinterrupt == 0 ) {
        ( $window, $progressbar, $timeout ) = progressbar("Processing...");
    }

    while (1) {
        Gtk2->main_iteration while Gtk2->events_pending;
        $ref = backgroundqueuepop( $self->deq_id, $self->q );
        if ( !defined($ref) or length( $ref->[0] ) == 0 ) {
            eval {
                if ( $main::globaldbierr[2] == 1 )
                {
                    my $reason = $main::globaldbierr[ 2 + 5 ];
                    my ($answer) = myquestion(
"You have been disconnected from your local database due to the following reason:\n\n$reason\n\nWould you like me to continue trying to reconnect? (Selecting No will cancel the current query)",
                        $window
                    );

                    $main::globaldbierr[2] = 0;
                    $main::globaldbierr[ 2 + 5 ] = '';
                    if ( $answer ne 'accept' ) {
                        $generror = 1;
                        $main::globalsqltoken{$main::token} = 1;
                        last;
                    }
                }

            };
            next;
        }
        last;
    }
    destroyprogressbar( $window, $progressbar, $timeout )
      if ( $main::globalprogressbarinterrupt == 0 );

    $ref;
}

1;
