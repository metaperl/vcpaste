Ok. We have 120,000 lines of code spanning several .pm files. Prior to
my arrival, all .pm files did _not_ have:
* use strict
* use warnings
* a package declaration at top


Now, along comes me and my Moose, strict and warnings. I was just fine
when coding my stuff by myself, but now I must integrate with the
large mass of code lacking the above best practices.

I've found out that variables and subs imported from packages with no
specific package are accessed via package qualifying them with the
package importing them. And this will make things tricky for me, based
on which of my packages `use` his.

Everything he does is in the main package since he never changed the
package. So, I'm wondering if I could write some sort of adaptor that
allowed me to call the subs and access the variables from his mass of
naked packages without concern for which of my packages
`use`d his, similar to him having global access to all
variables and subs with no package qualification.

I suppose the simplest thing is to always import his modules from one
single module of my own:

```perl
package Local::Main;

use strict;
use warnings;

BEGIN { my @pkg = qw(a b c d e f g);
  use $_ for @pkg;
}
```

(or something along those lines)

