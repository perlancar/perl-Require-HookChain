## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::munge::prepend;

#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, $preamble) = @_;
    bless { preamble => $preamble }, $class;
}

sub Require::HookChain::munge::prepend::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    my $src = $r->src;
    return unless defined $src; # XXX warn? or log_trace?

    $src = "$self->{preamble};\n$src";
    $r->src($src);
}

1;
# ABSTRACT: Prepend a piece of code to module source

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain -end=>1, 'munge::prepend' => 'use strict'; # the semicolon and newline is added automatically

The above has a similar effect to:

 use everywhere 'strict';

because it will prepend this line to each source code being loaded:

 use strict;


=head1 DESCRIPTION

Note that this hook should be put after other sources so by the time this hook
runs, the source code is already available.


=head1 FAQ

=head2 It doesn't work, it does not munge source code!

You might've installed the hook like this:

 use Require::HookChain 'munge::prepend' => '...';

in which case the hook is installed at the beginning of C<@INC> (after RHC's own
hook). When a user C<require>'s a module, by the time the C<munge::prepend> hook
runs, the source code is not yet available.


=head1 SEE ALSO

L<Require::HookChain>
