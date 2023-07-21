## no critic: TestingAndDebugging::RequireUseStrict
package RHC;
use alias::module 'Require::HookChain';

1;
# ABSTRACT: Short alias for Require::HookChain

=for Pod::Coverage ^(blessed)$

=head1 SYNOPSIS

On the command-line:

 # add 'use strict' to all loaded modules
 % perl -MRHC=munge::prepend,'use strict' ...


=head1 DESCRIPTION

This is a short alias for L<Require::HookChain> for less typing on the
command-line.


=head1 SEE ALSO

L<Require::HookChain>
