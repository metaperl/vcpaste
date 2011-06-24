package A;
use Moose;
use Carp;
has 'request' => (
  is => 'rw',
  trigger => \&_warnrequest
 );

has 'response' => (
  is => 'rw',
  trigger => \&_warnresponse
 );

has 'tree' => (is => 'rw');

has 'warnrequest'  => (is => 'rw', default => 0);
has 'warnresponse' => (is => 'rw', default => 0);

sub _warnrequest {
  my ($self)=@_;
  $self->warnrequest and Carp::cluck($self->request);
}

sub _warnresponse {
  my ($self)=@_;
  $self->warnresponse and Carp::cluck($self->response);
}

sub dumper {
  my ($self, $ref)=@_;
  use Data::Dumper;
  warn Dumper($ref);
}



1;

package B;
use Moose;
extends 'A';

package C;
use Moose;
extends 'B';

package main;

my $c = C->new(warnrequest => 1, warnresponse => 1);

$c->dumper($c);
