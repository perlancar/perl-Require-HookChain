## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::test::noop;

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub Require::HookChain::test::noop::INC {
    return ();
}

1;
# ABSTRACT: Do nothing when a module is loaded

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'test::noop';
 # now each subsequent require() will behave the same as before


=head1 DESCRIPTION

For testing only.

This hook does nothing, the hook always declines. Require::HookChain will just
move on to other hooks that do something.


=head1 SEE ALSO

L<Require::HookChain::test::noop_all>
