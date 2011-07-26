# vcpaste

A tool to turn use a github repo as a pastebin

## Overview

The command-line tool, `vcpaste.pl`, takes a file or folder name (relative or absolute) and "pastes" the
file to a new timestamped directory on github:

```
shell> vcpaste.pl ~/use/problem.cpp
Paste available at https://github.com/guy/vcpaste/blob/master/paste/2011-06-21-12-41-30/problem.cpp
```

(as stated, you can also paste an entire directory to github)

```
shell> vcpaste.pl ~/use
Paste available at https://github.com/metaperl/vcpaste/blob/master/paste/2011-07-26-13-31-06/use
```

# INSTALLATION

## CPAN modules

Install the CPAN modules listed in 
[the Makefile](https://github.com/metaperl/vcpaste/blob/master/Makefile) via `make cpan` 
on Unix/Linux or manually on Windows.

# AUTHOR

Terrence Brannon

## Acknowledgements

Rocco Caputo and Chris Prather

