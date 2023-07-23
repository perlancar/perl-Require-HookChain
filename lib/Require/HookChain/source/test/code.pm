## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::source::test::code;

#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, $code) = @_;
    bless { code => $code }, $class;
}

sub Require::HookChain::source::test::code::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    $r->src($self->{code}->($r));
    1;
}

1;
# ABSTRACT: Specify a code to provide source code

=for Pod::Coverage .+

=head1 SYNOPSIS

In Perl code:

 use Require::HookChain 'source::test::code' => sub { my $r = shift; $r->src("1;\n") unless defined $r->src };
 use Foo; # will use "1;\n" as source code even if the real Foo.pm is installed

On the command-line:

 # will use code if Foo is not installed
 % perl -E'use RHC -end =>1, "source::test::code" => sub { my $r = shift; $r->src("1;\n") unless defined $r->src }; use Foo; ...'


=head1 DESCRIPTION

This is a test hook to call specified code to provide source code of modules you
are loading. The code is called with C<$r> (see
L<Require::HookChain/"Require::HookChain::r OBJECT">) as the argument. To
provide source code, you can call C<< $r->src >> as shown in Synopsis.

You can also achieve the same effect by directly installing an C<@INC> hook
without the L<Require::HookChain> framework like this:

 unshift @INC, sub { ... };


=head1 SEE ALSO

L<Require::HookChain>

Other C<Require::HookChain::source::*>
