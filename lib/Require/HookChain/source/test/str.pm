## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::source::test::str;

#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, $src) = @_;
    bless { src => $src }, $class;
}

sub Require::HookChain::source::test::str::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    $r->src($self->{src});
    return 1;
}

1;
# ABSTRACT: Use a constant string as source code

=for Pod::Coverage .+

=head1 SYNOPSIS

In Perl code:

 use Require::HookChain 'source::test::str' => "1;\n";
 use Foo; # will use "1;\n" as source code even if the real Foo.pm is installed

On the command-line:

 # will use string '1' if Foo is not installed
 % perl -MRHC=-end,1,source::test::src,1 -MFoo -E...


=head1 DESCRIPTION

This is a test hook.


=head1 SEE ALSO

L<Require::HookChain>

Other C<Require::HookChain::source::*>
