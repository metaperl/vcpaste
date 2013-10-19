I installed the Homebrew version of Postgres via

    brew install postgresql

And then did a `cp /usr/local/Cellar/postgresql/9.2.3/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/` to add a lunchy launcher for it.

Then I pointed the [https://github.com/metaperl/vcpaste/blob/master/build-psycopg2-on-osx-with-brew/setup.cfg](setup.cfg) to it and typed `python setup.py build`
but then I got this error:

```
ld: warning: ignoring file
/usr/local/Cellar/postgresql/9.2.3/lib/libpq.dylib, file was built for
unsupported file format ( 0xcf 0xfa 0xed 0xfe 0x 7 0x 0 0x 0 0x 1 0x 3
0x 0 0x 0 0x 0 0x 6 0x 0 0x 0 0x 0 ) which is not the architecture
being linked (i386):
/usr/local/Cellar/postgresql/9.2.3/lib/libpq.dylib
```

so it seems there is something odd about the build of libpq by brew
(from the standpoint of [psycopg2](http://initd.org/psycopg/) )
