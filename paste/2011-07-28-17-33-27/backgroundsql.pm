use DBIx::Simple;
use Local::DBIx::Simple;

sub backgroundsql
{
	my ($dbhref,$query,$parameters,$generror,$refreshdbh,$closedbh,$begin,$end,$lastid,$token) = @_;
	
	my $dbierr;
	
	my @array;
	my $sth;
	my ($name,$type);
	
	eval
	{
	
	if($globalclosedbhforce == 1 && $globaltransaction == 0)
	{
		eval { $$dbhref->disconnect(); };
		($$dbhref) = dbreconnect($$dbhref);
	}
	
	if($generror == 1 && ($query eq 'ROLLBACK' || $end == 1))
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
		if($closedbh == 1 && $globalclosedbh == 1) { eval { $$dbhref->disconnect(); }; }
		return($generror,undef);
	}
	elsif($generror == 1) { return($generror,undef); }
	
	if($globalclosedbhforce == 0 && $refreshdbh == 1 && $globalclosedbh == 1 && $shareddatabase == 1) { ($$dbhref) = dbreconnect($$dbhref); }
	elsif($globalclosedbhforce == 0 && $refreshdbh == 1 && $shareddatabase == 1 && (!defined($$dbhref) || !$$dbhref->ping)) { ($$dbhref) = dbreconnect($$dbhref); }
	
	$dbierr = DBI::errstr;
	
	if(!defined($$dbhref)) { return(1,undef,$dbierr); }
	
	if($begin == 1)
	{
		$globaltransaction = 1;
		$$dbhref->begin_work;
	}
	
	my $followthrough = 0;
	
	if($query ne 'COMMIT' && $query ne 'ROLLBACK' && $query ne 'BEGIN')
	{
		my @p = @$parameters;
		map { $_ eq '' and $_ = undef } (@p);
		
		if($globalasync == 1)
		{
			$sth = $$dbhref->prepare($query, {pg_async => PG_ASYNC}) or $generror = 1;
			$sth->execute(@p) or $generror = 1;
			
			my $completed = 0;
			my $endtime = time + $globalasynctimeout;
			while(time < $endtime)
			{
				if($sth->pg_ready)
				{
					$completed = 1;
					last;
				}
				usleep(100000);
			}
			
			if($completed == 0)
			{
				$generror = 1;
				$$dbhref->pg_cancel();
			}
			else
			{
				$sth->pg_result();
				if($query =~ /^SELECT/ && $generror == 0)
				{
					while(my @val = $sth->fetchrow_array()) { push(@array,[@val]); }
				}
			}
		}
		else
		{
			$sth = $$dbhref->prepare($query) or $generror = 1;
			$sth->execute(@p) or $generror = 1;
			if($query =~ /^SELECT/ && $generror == 0)
			{
				while(my @val = $sth->fetchrow_array()) { push(@array,[@val]); }
			}
		}
		
		if($query =~ /^SELECT report\_/)
		{
			my $ref = $array[0][0];
			@array = @$ref;
		}
		
		if(defined($sth))
		{
			$name = $sth->{NAME};
			$type = $sth->{TYPE};
			$dbierr = $sth->errstr();
		}
		
		if(defined($sth)) { $sth->finish(); }
		undef($sth);
	}
	
	if(length($lastid) > 0)
	{
		my @a = split(/,/, $lastid);
		map { $_ eq '' and $_ = undef } ($a[0],$a[1]);
		$array[0] = $$dbhref->last_insert_id(undef,undef,$a[0],$a[1]);
	}
	
	if($query eq 'COMMIT')
	{
		$globaltransaction = 0;
		$$dbhref->commit;
	}
	elsif($query eq 'ROLLBACK')
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
	}
	elsif($end == 1 && $generror == 0)
	{
		$globaltransaction = 0;
		$$dbhref->commit;
	}
	elsif($end == 1)
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
	}
	
	$followthrough = 1;
	
	if($closedbh == 1 && $globalclosedbh == 1) { eval { $$dbhref->disconnect(); }; }
	
	};
	
	eval
	{
	
	if($followthrough == 0 && $generror == 1 && $end == 1)
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
		
		if($closedbh == 1 && $globalclosedbh == 1) { eval { $$dbhref->disconnect(); }; }
	}
	
	};
	
	return($generror,\@array,$dbierr,$name,$type);
}
sub standardsql
{
	my ($dbhref,$query,$parameters,$generror,$refreshdbh,$closedbh,$begin,$end,$lastid) = @_;
	
	my $dbierr;
	
	my @array;
	my $sth;
	my ($name,$type);
	
	eval
	{
	
	if($generror == 1 && ($query eq 'ROLLBACK' || $end == 1))
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
		return($generror,undef);
	}
	elsif($generror == 1) { return($generror,undef); }
	
	if($refreshdbh == 1 && $shareddatabase == 1 && (!defined($$dbhref) || !$$dbhref->ping)) { ($$dbhref) = dbreconnect($$dbhref); }
	
	$dbierr = DBI::errstr;
	
	if(!defined($$dbhref)) { return(1,undef,$dbierr); }
	
	if($begin == 1)
	{
		$globaltransaction = 1;
		$$dbhref->begin_work;
	}
	
	my $followthrough = 0;
	
	if($query ne 'COMMIT' && $query ne 'ROLLBACK' && $query ne 'BEGIN')
	{
		my @p = @$parameters;
		map { $_ eq '' and $_ = undef } (@p);
		
		$sth = $$dbhref->prepare($query) or $generror = 1;
		$sth->execute(@p) or $generror = 1;
		if($query =~ /^SELECT/ && $generror == 0)
		{
			while(my @val = $sth->fetchrow_array()) { push(@array,[@val]); }
		}
		
		if($query =~ /^SELECT report\_/)
		{
			my $ref = $array[0][0];
			@array = @$ref;
		}
		
		if(defined($sth))
		{
			$name = $sth->{NAME};
			$type = $sth->{TYPE};
			$dbierr = $sth->errstr();
		}
		
		if(defined($sth)) { $sth->finish(); }
		undef($sth);
	}
	
	if(length($lastid) > 0)
	{
		my @a = split(/,/, $lastid);
		map { $_ eq '' and $_ = undef } ($a[0],$a[1]);
		$array[0] = $$dbhref->last_insert_id(undef,undef,$a[0],$a[1]);
	}
	
	if($query eq 'COMMIT')
	{
		$globaltransaction = 0;
		$$dbhref->commit;
	}
	elsif($query eq 'ROLLBACK')
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
	}
	elsif($end == 1 && $generror == 0)
	{
		$globaltransaction = 0;
		$$dbhref->commit;
	}
	elsif($end == 1)
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
	}
	
	$followthrough = 1;
	
	};
	
	eval
	{
	
	if($followthrough == 0 && $generror == 1 && $end == 1)
	{
		$globaltransaction = 0;
		$$dbhref->rollback;
	}
	
	};
	
	return($generror,\@array,$dbierr,$name,$type);
}
sub foregroundsql
{
	my ($query,$parameters,$generror,$refreshdbh,$closedbh,$begin,$end,$lastid) = @_;
	
	if($globalstandardconnection == 1)
	{
		my ($generror,$arrayref,$dbierr,$name,$type) = standardsql(\$globaldbh,$query,$parameters,$generror,$refreshdbh,$closedbh,$begin,$end,$lastid);
		return($generror,$arrayref,$dbierr,$name,$type);
	}
	
	my $token = int(rand(1000000000));
	
	my @queue;
	push(@queue,2,$query,$parameters,$generror,$refreshdbh,$closedbh,$begin,$end,$lastid,$token);
	$main::backgroundqueue->enqueue(\@queue);
	
	my ($generror,$arrayref,$dbierr,$name,$type);
	
	my ($window,$progressbar,$timeout);
	
	if($globalprogressbarinterrupt == 0) { ($window,$progressbar,$timeout) = progressbar("Processing..."); }
	
	#print "Processing query: $query\n\n";
	
	while(1)
	{
		Gtk2->main_iteration while Gtk2->events_pending;
		my $ref = main::backgroundqueuepop(4,$main::backgroundqueue);
		if(!defined($ref) || length($ref->[0]) == 0)
		{
			eval
			{
				if($globaldbierr[2] == 1)
				{
					my $reason = $globaldbierr[2 + 5];
					my ($answer) = myquestion("You have been disconnected from your local database due to the following reason:\n\n$reason\n\nWould you like me to continue trying to reconnect? (Selecting No will cancel the current query)",$window);
					
					$globaldbierr[2] = 0;
					$globaldbierr[2 + 5] = '';
					if($answer ne 'accept')
					{
						$generror = 1;
						$globalsqltoken{$token} = 1;
						last;
					}
				}
				
			};
			next;
		}
		
		$generror = $ref->[1];
		$arrayref = $ref->[2];
		$dbierr = $ref->[3];
		$name = $ref->[4];
		$type = $ref->[5];
		last;
	}
	
	if($globalprogressbarinterrupt == 0) { destroyprogressbar($window,$progressbar,$timeout); }
	
	return($generror,$arrayref,$dbierr,$name,$type);
      }
sub backgroundxml
{
	my ($xmlsend,$timeout) = @_;
	
	my ($server,$host) = serverconnect(0);
	
	my $recvref;
	
	if(!defined($server))
	{
		$recvref->{'error'} = "Could not connect to server.";
		my $xml = $xmlsimple2->XMLout($recvref);
		return($xml);
	}
	
	xmlsend($server,$xmlsend,undef,$timeout,undef);
# 	print "Sent data\n";
	
	my ($xmlrecv) = xmlrecv($server,undef,$timeout,undef);
	
	if(length($xmlrecv) == 0)
	{
		$recvref->{'error'} = "No data received from server.";
		my $xml = $xmlsimple2->XMLout($recvref);
		return($xml);
	}
	return($xmlrecv);
      }

sub _backgroundxml {

			my $xmlrecv = backgroundxml($ref->[1],$ref->[2]);
			
			my @queue;
			push(@queue,3,$xmlrecv);
			$queue->enqueue(\@queue);
		      }

sub _backgroundsql
		{
			if(!defined($dbh)) { $dbh = dbconnect(); }
			
			if($globalsqltoken{$ref2->[9]} == 1)
			{
				undef($globalsqltoken{$ref2->[9]});
				next;
			}
			
			my ($generror,$arrayref,$dbierr,$name,$type) = backgroundsql(\$dbh,$ref2->[1],$ref2->[2],$ref2->[3],$ref2->[4],$ref2->[5],$ref2->[6],$ref2->[7],$ref2->[8]);
			
			if($globalsqltoken{$ref2->[9]} == 1)
			{
				undef($globalsqltoken{$ref2->[9]});
				next;
			}
			
			my @queue;
			push(@queue,4,$generror,$arrayref,$dbierr,$name,$type);
			$queue->enqueue(\@queue);
		      }

sub _simplequery {
  my($ref)=@_;
  my($self,$query,@binds) =@$ref;
  my $ldbs = Local::DBIx::Simple->new;
  my $result = $ldbs->dbs->query($query,@binds);
  $ldbs->q->enqueue($self->deq_id, $ref);
}

sub _simplehashes {
  my($ref)=@_;
  my($lbdsr) =@$ref;
  bless $lbdsr, 'DBIx::Simple::Result';
  my $hashes = $ldbsr->hashes;
  $ldbsr->q->enq($hashes);
}

my %backgroundops = (
  1 => \&_backgroundxml,
  2 => \&_backgroundsql,
  5 => \&_simplequery,
  7 => \&_simplehashes,
);  

sub backgroundprocess
{
	my ($queue) = @_;
	
	$xmlsimple2 = XML::Simple->new(ForceArray => 0, NoAttr => 1, KeyAttr => [], RootName => 'xml', SuppressEmpty => '');
	
	my $dbh;
	
	while(1)
	{
		if($cleanexit == 1) { last; }
		
		if($globalstandardconnection == 1)
		{
			if($gtkrunning == 0)
			{
				sleep(5);
				next;
			}
			
			if(1 == 1)
			{
				usleep(100000);
				lock($newdocument);
				if($newdocument != 1) { next; }
			}
			
			if($shareddatabase == 1 && (!defined($dbh) || !$dbh->ping)) { $dbh = dbreconnect($dbh); }
			elsif($shareddatabase == 0 && !defined($dbh)) { $dbh = dbconnect(); }
		
			my $data;
			
			my $generror;
			my $query = "SELECT docdata FROM $newdocumenttable WHERE docid = ?";
			my $sth = $dbh->prepare($query);
			map { $_ eq '' and $_ = undef } ($newdocumentid);
			$sth->execute($newdocumentid) or $generror = 1;
			while(my @newval = $sth->fetchrow_array()) { $data = decode_base64($newval[0]); }
			$sth->finish();
			undef($sth);
			
			if(1 == 1)
			{
				lock($newdocument);
				lock($newdocumentdata);
				
				$newdocumentdata = $data;
				$newdocument = 0;
			}
			
			next;
		}

		my @action_keys = qw(1 2 5);      # 1, 3 for xml. 2,4 for tjsql. 5, 6 for dbixsimple
		for my $action_key (@action_key) {
		  $ref = $ref2 = backgroundqueuepop($action_key,$queue); # deal with 

		  if (List::MoreUtils::any { $_ == $action_key } qw(1 2)) {
		    unless ( defined($ref) and length($ref->[0]) )
		{
			usleep(1000);
			next;
		}

		  }
		    $backgroundops{$action_key}->($ref);

		
		if($cleanexit == 1) { last; }
		}
		
		usleep(1000);
		}
	eval { $dbh->disconnect(); };
	return(1);
      }
sub backgroundqueuepop
{
	my ($itemtype,$queue) = @_;
	
	my $extractref;
	my $lastqueue;
	my $count = $queue->pending();
#	print "Pending: $count\n";
	my $i;
	lock($queue);
	for($i=0;$i<$count;$i++)
	{
#		print "\tchecking: $i\n";
		my $ref = $queue->peek($i);
		if(defined($ref))
		{
#			print "\t\tDefined! Ref0 is: " . $ref->[0] . "\n";
			if($ref->[0] == $itemtype)
			{
				$extractref = $queue->extract($i);
				$count--;
				$i--;
				
			}
		}
	}
	
	return($extractref);
	
      }
1;
