{

    package TJ;

    #use Class::MOP;

    #my @pkg = qw(createnewdb dbconnect);

    #Class::MOP::load_class($_) for @pkg;
}

{
    package main;

    use biotrackthc;
    eval { require  biotrackthc2; };
    die $@ if $@;

}

1;
