when I run `prove -lr threaded.t` [here is
threaded.t](https://github.com/metaperl/vcpaste/blob/master/paste/2011-07-29-10-56-44/threaded.t),
there is an error because it calls use TJ and
[TJ.pm](https://github.com/metaperl/vcpaste/blob/master/paste/2011-07-29-10-56-44/TJ.pm)
fails on theline `use biotrackthc2` because there are syntax errors in
biotrackthc2.pm. That's all fine. But what bothers me is without `eval
{ require biotrackthc2 }; die $@ if $@;`, I do not get any report of
problems with that file from running `prove`
