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
    return unless defined $src;
    $src = "$self->{preamble};\n$src";
    $r->src($src);
}

1;
# ABSTRACT: Prepend a piece of code to module source

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'munge::prepend' => 'use strict'; # the semicolon and newline is added automatically

The above has a similar effect to:

 use everywhere 'strict';

because it will prepend this line to each source code being loaded:

 use strict;


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::HookChain>
