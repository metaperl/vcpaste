package DBIx::Array;
use strict;
use warnings;
use DBI;

our $VERSION='0.22';

=head1 NAME

DBIx::Array - This module is a wrapper around DBI with array interfaces

=head1 SYNOPSIS

  use DBIx::Array;
  my $dbx=DBIx::Array->new;
  $dbx->connect($connection, $user, $pass, \%opt); #passed to DBI
  my @array=$dbx->sqlarray($sql, @params);

=head1 DESCRIPTION

This module is for people who truly understand SQL and who understand Perl data structures.  If you understand how to modify your SQL to meet your data requirements then this module is for you.  In the example below, only one line of code is needed to generate an entire HTML table.

  print &tablename($dba->sqlarrayarrayname(&sql, 15)), "\n";

  sub tablename {
    use CGI; my $html=CGI->new(""); #you would pass this reference
    return $html->table($html->Tr([map {$html->td($_)} @_]));
  }
   
  sub sql { #Oracle SQL
    return q{SELECT LEVEL AS "Number",
                    TRIM(TO_CHAR(LEVEL, 'rn')) as "Roman Numeral"
               FROM DUAL CONNECT BY LEVEL <= ? ORDER BY LEVEL};
  }

This module is used to connect to both Oracle 10g and 11g using L<DBD::Oracle> on both Linux and Win32, MySQL 4 and 5 using L<DBD::mysql> on Linux, and Microsoft SQL Server using L<DBD::Sybase> on Linux and using L<DBD:ODBC> on Win32 systems in a 24x7 production environment.  The tests are written against L<DBD::CSV> and L<DBD::XBase>.

=head1 USAGE

=head1 CONSTRUCTOR

=head2 new

  my $dbx=DBIx::Array->new();
  $dbx->connect(...); #connect to database, sets and returns dbh

  my $dbx=DBIx::Array->new(dbh=>$dbh); #already have a handle

=cut

sub new {
  my $this=shift;
  my $class=ref($this) || $this;
  my $self={};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=head2 initialize

=cut

sub initialize {
  my $self=shift;
  %$self=@_;
}

=head1 METHODS (Properties)

=head2 name

Sets or returns a user friendly identification string for this database connection

  my $name=$dbx->name;
  my $name=$dbx->name($string);

=cut

sub name {
  my $self=shift;
  $self->{'name'}=shift if @_;
  return $self->{'name'};
}

=head1 METHODS (DBI Wrappers)

=head2 connect

Connects to the database and returns the database handle.

  $dbx->connect($connection, $user, $pass, \%opt);

Pass through to DBI->connect;

Examples: 

  $dbx->connect("DBI:mysql:database=mydb;host=myhost", "user", "pass", {AutoCommit=>1, RaiseError=>1});

  $dbx->connect("DBI:Sybase:server=myhost;datasbase=mydb", "user", "pass", {AutoCommit=>1, RaiseError=>1}); #Microsoft SQL Server API is same as Sybase API

  $dbx->connect("DBI:Oracle:TNSNAME", "user", "pass", {AutoCommit=>1, RaiseError=>1});

=cut

sub connect {
  my $self=shift;
  my $dbh=DBI->connect(@_);
  return $self->dbh($dbh);
}

=head2 disconnect

Calls $dbh->disconnect

  $dbx->disconnect;

Pass through to dbh->disconnect

=cut

sub disconnect {
  my $self=shift;
  return $self->dbh->disconnect
}

=head2 commit

Pass through to dbh->commit

  $dbx->commit;

=cut

sub commit {
  my $self=shift;
  return $self->dbh->commit;
}

=head2 rollback

Pass through to dbh->rollback

  $dbx->rollback;

=cut

sub rollback {
  my $self=shift;
  return $self->dbh->rollback;
}

=head2 AutoCommit

Pass through to  dbh->{'AutoCommit'} or dbh->{'AutoCommit'}=shift;

  $dbx->AutoCommit(1);
  &doSomething if $dbx->AutoCommit;

For transactions that must complete together, I recommend

  { #block to keep local... well... local.
    local $dbx->dbh->{"AutoCommit"}=0;
    $dbx->insert($sql1, @bind1);
    $dbx->update($sql2, @bind2);
    $dbx->insert($sql3, @bind3);
  } #What is AutoCommit now?  Do you care?

If AutoCommit reverts to true at the end of the block then DBI commits.  Else AutoCommit is still false and still not committed.  This allows higher layers to determine commit functionality.

=cut

sub AutoCommit {
  my $self=shift;
  if (@_) {
    $self->dbh->{'AutoCommit'}=shift;
  }
  return $self->dbh->{'AutoCommit'};
}

=head2 RaiseError

Pass through to  dbh->{'RaiseError'} or dbh->{'RaiseError'}=shift;

  $dbx->RaiseError(1);
  &doSomething if $dbx->RaiseError;

  { #local block
    local $dbx->dbh->{"RaiseError"}=0;
    $dbx->insert($sql, @bind); #do not die
  }

=cut

sub RaiseError {
  my $self=shift;
  if (@_) {
    $self->dbh->{'RaiseError'}=shift;
  }
  return $self->dbh->{'RaiseError'};
}

=head2 errstr

Returns $DBI::errstr

  $dbx->errstr;

=cut

sub errstr {$DBI::errstr};

=head2 dbh

Sets or returns the database handle object.

  $dbx->dbh;
  $dbx->dbh($dbh);  #if you already have a connection

=cut

sub dbh {
  my $self=shift;
  if (@_) {
    $self->{'dbh'}=shift;
    $self->{"_prepared"}=undef; #clear cache if we switch handles
  }
  return $self->{'dbh'};
}

=head1 METHODS (Read)

=head2 sqlcursor

Returns the prepared and executed SQL cursor so that you can use the cursor elsewhere.  Every method in this package uses this single method to generate a sqlcursor.

  my $sth=$dbx->sqlcursor($sql,  @param); #binds are ? values are positional
  my $sth=$dbx->sqlcursor($sql, \@param); #binds are ? values are positional
  my $sth=$dbx->sqlcursor($sql, \%param); #binds are :key

Note: In true Perl fashion extra hash binds are ignored.

  my @foo=$dbx->sqlarray("select :foo, :bar from dual",
                         {foo=>"a", bar=>1, baz=>"buz"}); #returns ("a", 1)

  my $one=$dbx->sqlscalar("select ? from dual", ["one"]); #returns "one"

  my $two=$dbx->sqlscalar("select ? from dual", "two");   #returns "two"

Scalar refererences are passed in and out with a hash bind.

  my $inout=3;
  $dbx->execute("BEGIN :inout := :inout * 2; END;", {inout=>\$inout});
  print "$inout\n";  #$inout is 6

Direct Plug-in for L<SQL::Abstract> but no column alias support.

  my $sabs=SQL::Abstract->new;
  my $sth=$dbx->sqlcursor($sabs->select($table, \@fields, \%where, \@sort));

=cut

sub sqlcursor {
  my $self=shift;
  my $sql=shift;
  my $sth=$self->_prepared->{$sql};
  unless ($sth) {
    $sth=$self->dbh->prepare($sql)     or die($self->errstr);
    #clear cache if over limit
    $self->{"_prepared"}=undef if scalar(keys %{$self->_prepared}) > 16;
    $self->_prepared->{$sql}=$sth;
  }
  if (ref($_[0]) eq "ARRAY") {
    $sth->execute(@{$_[0]})            or die($self->errstr);
  } elsif (ref($_[0]) eq "HASH") {
    foreach my $key (keys %{$_[0]}) {
      next unless $sql=~m/:$key\b/;
      if (ref($_[0]->{$key}) eq "SCALAR") {
        $sth->bind_param_inout(":$key" => $_[0]->{$key}, 255);
      } else {
        $sth->bind_param(":$key" => $_[0]->{$key});
      }
    } 
    $sth->execute                      or die($self->errstr);
  } else {
    $sth->execute(@_)                  or die($self->errstr);
  }
  return $sth;
}

sub _prepared {
  my $self=shift;
  $self->{"_prepared"}={} unless ref($self->{"_prepared"}) eq "HASH";
  return $self->{"_prepared"};
}

=head2 sqlscalar

Returns the SQL result as a scalar.

This works great for selecting one value.

  my $scalar=$dbx->sqlscalar($sql,  @parameters); #returns $
  my $scalar=$dbx->sqlscalar($sql, \@parameters); #returns $
  my $scalar=$dbx->sqlscalar($sql, \%parameters); #returns $

=cut

sub sqlscalar {
  my $self=shift;
  my @data=$self->sqlarray(@_);
  return $data[0];
}

=head2 sqlarray

Returns the SQL result as an array or array reference.

This works great for selecting one column from a table or selecting one row from a table.

  my $array=$dbx->sqlarray($sql,  @parameters); #returns [$,$,$,...]
  my @array=$dbx->sqlarray($sql,  @parameters); #returns ($,$,$,...)
  my $array=$dbx->sqlarray($sql, \@parameters); #returns [$,$,$,...]
  my @array=$dbx->sqlarray($sql, \@parameters); #returns ($,$,$,...)
  my $array=$dbx->sqlarray($sql, \%parameters); #returns [$,$,$,...]
  my @array=$dbx->sqlarray($sql, \%parameters); #returns ($,$,$,...)

=cut

sub sqlarray {
  my $self=shift;
  my $rows=$self->sqlarrayarray(@_);
  my @rows=map {@$_} @$rows;
  return wantarray ? @rows : \@rows;
}

=head2 sqlhash

Returns the first two columns of the SQL result as a hash or hash reference {Key=>Value, Key=>Value, ...}

  my $hash=$dbx->sqlhash($sql,  @parameters); #returns {$=>$, $=>$, ...}
  my %hash=$dbx->sqlhash($sql,  @parameters); #returns ($=>$, $=>$, ...)
  my @hash=$dbx->sqlhash($sql,  @parameters); #this is ordered
  my @keys=grep {!($n++ % 2)} @hash;          #ordered keys

  my $hash=$dbx->sqlhash($sql, \@parameters); #returns {$=>$, $=>$, ...}
  my %hash=$dbx->sqlhash($sql, \@parameters); #returns ($=>$, $=>$, ...)
  my $hash=$dbx->sqlhash($sql, \%parameters); #returns {$=>$, $=>$, ...}
  my %hash=$dbx->sqlhash($sql, \%parameters); #returns ($=>$, $=>$, ...)

=cut

sub sqlhash {
  my $self=shift;
  my $rows=$self->sqlarrayarray(@_);
  my @rows=map {$_->[0], $_->[1]} @$rows;
  return wantarray ? @rows : {@rows};
}

=head2 sqlarrayarray

Returns the SQL result as an array or array ref of array references ([],[],...) or [[],[],...]

  my $array=$dbx->sqlarrayarray($sql,  @parameters); #returns [[$,$,...],[],[],...]
  my @array=$dbx->sqlarrayarray($sql,  @parameters); #returns ([$,$,...],[],[],...)
  my $array=$dbx->sqlarrayarray($sql, \@parameters); #returns [[$,$,...],[],[],...]
  my @array=$dbx->sqlarrayarray($sql, \@parameters); #returns ([$,$,...],[],[],...)
  my $array=$dbx->sqlarrayarray($sql, \%parameters); #returns [[$,$,...],[],[],...]
  my @array=$dbx->sqlarrayarray($sql, \%parameters); #returns ([$,$,...],[],[],...)

=cut

sub sqlarrayarray {
  my $self=shift;
  my $sql=shift;
  return $self->_sqlarrayarray(sql=>$sql, param=>[@_], name=>0);
}

=head2 sqlarrayarrayname

Returns the SQL result as an array or array ref of array references ([],[],...) or [[],[],...] where the first row contains an array reference to the column names

  my $array=$dbx->sqlarrayarrayname($sql,  @parameters); #returns [[$,$,...],[]...]
  my @array=$dbx->sqlarrayarrayname($sql,  @parameters); #returns ([$,$,...],[]...)
  my $array=$dbx->sqlarrayarrayname($sql, \@parameters); #returns [[$,$,...],[]...]
  my @array=$dbx->sqlarrayarrayname($sql, \@parameters); #returns ([$,$,...],[]...)
  my $array=$dbx->sqlarrayarrayname($sql, \%parameters); #returns [[$,$,...],[]...]
  my @array=$dbx->sqlarrayarrayname($sql, \%parameters); #returns ([$,$,...],[]...)

Create an HTML table with L<CGI>

  my $cgi=CGI->new;
  my $html=$cgi->table($cgi->Tr([map {$cgi->td($_)} $dbx->sqlarrayarrayname($sql, @param)]));

=cut

sub sqlarrayarrayname {
  my $self=shift;
  my $sql=shift;
  return $self->_sqlarrayarray(sql=>$sql, param=>[@_], name=>1);
}

=head2 _sqlarrayarray

  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[ @parameters], name=>1);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[ @parameters], name=>1);
  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[ @parameters], name=>0);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[ @parameters], name=>0);

  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\@parameters], name=>1);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\@parameters], name=>1);
  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\@parameters], name=>0);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\@parameters], name=>0);

  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\%parameters], name=>1);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\%parameters], name=>1);
  my $array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\%parameters], name=>0);
  my @array=$dbx->_sqlarrayarray(sql=>$sql, param=>[\%parameters], name=>0);

=cut

sub _sqlarrayarray {
  my $self=shift;
  my %data=@_;
  my $sth=$self->sqlcursor($data{'sql'}, @{$data{'param'}}) or die($self->errstr);
  my $name=$sth->{'NAME'}; #DBD::mysql must store this first
  my $row=[];
  my @rows=();
  while ($row=$sth->fetchrow_arrayref()) {
    push @rows, [@$row];
  }
  unshift @rows, $name if $data{'name'};
  $sth->finish;
  return wantarray ? @rows : \@rows;
}

=head2 sqlarrayhash

Returns the SQL result as an array or array ref of hash references ({},{},...) or [{},{},...]

  my $array=$dbx->sqlarrayhash($sql,  @parameters); #returns [{},{},{},...]
  my @array=$dbx->sqlarrayhash($sql,  @parameters); #returns ({},{},{},...)
  my $array=$dbx->sqlarrayhash($sql, \@parameters); #returns [{},{},{},...]
  my @array=$dbx->sqlarrayhash($sql, \@parameters); #returns ({},{},{},...)
  my $array=$dbx->sqlarrayhash($sql, \%parameters); #returns [{},{},{},...]
  my @array=$dbx->sqlarrayhash($sql, \%parameters); #returns ({},{},{},...)

This method is best used to select a list of hashes out of the database to bless directly into a package.

  my $sql=q{SELECT COL1 AS "id", COL2 AS "name" FROM TABLE1};
  my @objects=map {bless $_, MyPackage} $dbx->sqlarrayhash($sql,  @parameters);
  my @objects=map {MyPackage->new(%$_)} $dbx->sqlarrayhash($sql,  @parameters);

The @objects array is now a list of blessed MyPackage objects.

=cut

sub sqlarrayhash {
  my $self=shift;
  my $sql=shift;
  return $self->_sqlarrayhash(sql=>$sql, param=>[@_], name=>0);
}

=head2 sqlarrayhashname

Returns the SQL result as an array or array ref of hash references ([],{},{},...) or [[],{},{},...] where the first row contains an array reference to the column names

  my $array=$dbx->sqlarrayhashname($sql,  @parameters); #returns [[],{},{},...]
  my @array=$dbx->sqlarrayhashname($sql,  @parameters); #returns ([],{},{},...)
  my $array=$dbx->sqlarrayhashname($sql, \@parameters); #returns [[],{},{},...]
  my @array=$dbx->sqlarrayhashname($sql, \@parameters); #returns ([],{},{},...)
  my $array=$dbx->sqlarrayhashname($sql, \%parameters); #returns [[],{},{},...]
  my @array=$dbx->sqlarrayhashname($sql, \%parameters); #returns ([],{},{},...)

=cut

sub sqlarrayhashname {
  my $self=shift;
  my $sql=shift;
  return $self->_sqlarrayhash(sql=>$sql, param=>[@_], name=>1);
}

=head2 _sqlarrayhash

Returns the SQL result as an array or array ref of hash references ({},{},...) or [{},{},...]

  my $array=$dbx->_sqlarrayhash(sql=>$sql, param=>\@parameters, name=>1);
  my @array=$dbx->_sqlarrayhash(sql=>$sql, param=>\@parameters, name=>1);
  my $array=$dbx->_sqlarrayhash(sql=>$sql, param=>\@parameters, name=>0);
  my @array=$dbx->_sqlarrayhash(sql=>$sql, param=>\@parameters, name=>0);

=cut

sub _sqlarrayhash {
  my $self=shift;
  my %data=@_;
  my $sth=$self->sqlcursor($data{'sql'}, @{$data{'param'}}) or die($self->errstr);
  my $name=$sth->{'NAME'}; #DBD::mysql must store this first
  my $row=[];
  my @rows=();
  while ($row=$sth->fetchrow_hashref()) {
    push @rows, {%$row};
  }
  unshift @rows, $name if $data{'name'};
  $sth->finish;
  return wantarray ? @rows : \@rows;
}

=head2 sqlsort (Oracle Specific?)

Returns the SQL statement with the correct ORDER BY clause given a SQL statement (without an ORDER BY clause) and a signed integer on which column to sort.

  my $sql=$dbx->sqlsort(qq{SELECT 1,'Z' FROM DUAL UNION SELECT 2,'A' FROM DUAL}, -2);

Returns

  SELECT 1,'Z' FROM DUAL UNION SELECT 2,'A' FROM DUAL ORDER BY 2 DESC

=cut 

sub sqlsort {
  my $self=shift;
  my $sql=shift;
  my $sort=shift;
  if (defined($sort) and $sort=int($sort)) {
    my $column=abs($sort);
    my $direction = $sort < 0 ? "DESC" : "ASC";
    return join " ", $sql, sprintf("ORDER BY %u %s", $column, $direction);  
  } else {
    return $sql;
  }
}

=head2 sqlarrayarraynamesort

Returns a sqlarrayarrayname for $sql sorted on column $n where n is an integer ascending for positive, descending for negative, and 0 for no sort.

  my $data=$dbx->sqlarrayarraynamesort($sql, $n,  @parameters);
  my $data=$dbx->sqlarrayarraynamesort($sql, $n, \@parameters);
  my $data=$dbx->sqlarrayarraynamesort($sql, $n, \%parameters);

Note: $sql must not have an "ORDER BY" clause in order for this function to work correctly.

=cut

sub sqlarrayarraynamesort {
  my $self=shift;
  my $sql=shift;
  my $sort=shift;
  return $self->sqlarrayarrayname($self->sqlsort($sql, $sort), @_);
} 

=head1 METHODS (Write)

Remember to commit or use AutoCommit

Note: It appears that some drivers do not support the count of rows.  

=head2 insert

Returns the number of rows inserted by the SQL statement.

  my $rows=$dbx->insert( $sql,   @parameters);
  my $rows=$dbx->insert( $sql,  \@parameters);
  my $rows=$dbx->insert( $sql,  \%parameters);

  my $sabs=SQL::Abstract->new;
  my $rows=$dbx->insert($sabs->insert($table, \%field));

=cut

*insert=\&update;

=head2 update

Returns the number of rows updated by the SQL statement.

  my $rows=$dbx->update( $sql,   @parameters);
  my $rows=$dbx->update( $sql,  \@parameters);
  my $rows=$dbx->update( $sql,  \%parameters);

  my $sabs=SQL::Abstract->new;
  my $rows=$dbx->update($sabs->update($table, \%field, \%where));

=cut

sub update {
  my $self=shift;
  my $sql=shift;
  my $sth=$self->sqlcursor($sql, @_) or die($self->errstr);
  my $rows=$sth->rows;
  $sth->finish;
  return $rows;
}

=head2 delete

Returns the number of rows deleted by the SQL statement.

  my $rows=$dbx->delete( $sql,   @parameters);
  my $rows=$dbx->delete( $sql,  \@parameters);
  my $rows=$dbx->delete( $sql,  \%parameters);

  my $sabs=SQL::Abstract->new;
  my $rows=$dbx->delete($sabs->delete($table, \%where));

Note: Some Oracle clients do not support row counts on delete instead the value appears to be a success code.

=cut

*delete=\&update;

=head2 execute, exec

Executes stored proceedures.

  my $out;
  my $rows=$dbx->execute($sql, $in, \$out);            #pass in/out vars as scalar reference
  my $rows=$dbx->execute($sql, [$in, \$out]);
  my $rows=$dbx->execute($sql, {in=>$in, out=>\$out});

=cut

*execute=\&update;
*exec=\&update;   #deprecated

=head1 TODO

Sort functions may not be portable.

=head1 BUGS

Send email to author and log on RT.

=head1 SUPPORT

DavisNetworks.com supports all Perl applications including this package.

=head1 AUTHOR

  Michael R. Davis
  CPAN ID: MRDVT
  STOP, LLC
  domain=>stopllc,tld=>com,account=>mdavis
  http://www.stopllc.com/

=head1 COPYRIGHT

This program is free software licensed under the...

  The BSD License

The full text of the license can be found in the LICENSE file included with this module.

=head1 SEE ALSO

=head2 The Competition

L<DBIx::DWIW>, L<DBIx::Wrapper>, L<DBIx::Simple>, L<Data::Table::fromSQL>, L<DBIx::Wrapper::VerySimple>

=head2 The Building Blocks

L<DBI>, L<SQL::Abstract>

=cut

1;
