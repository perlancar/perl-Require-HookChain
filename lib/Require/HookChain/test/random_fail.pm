## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::test::random_fail;

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, $probability) = @_;
    $probability = 0.5 unless defined $probability;
    bless {probability=>$probability}, $class;
}

sub Require::HookChain::test::random_fail::INC {
    my ($self, $r) = @_;

    if (rand() < $self->{probability}) {
        my $filename = $r->filename;
        die "Can't locate $filename: test::random_fail";
    }
    ();
}

1;
# ABSTRACT: Fail a module loading randomly

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'test::random_fail', 0.25; # probability, default is 0.5 (50%)
 # now each subsequent require() will ~25% fail


=head1 DESCRIPTION

For testing only.


=head1 SEE ALSO

L<Require::HookChain::test::fail>
