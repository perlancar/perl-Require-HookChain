## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::timestamp::hires;

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT

use Time::HiRes qw(time);

# AUTHORITY
# DATE
# DIST
# VERSION

our %Timestamps; # key=module name, value=epoch

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub Require::HookChain::timestamp::hires::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    $Timestamps{$r->filename} = time()
        unless defined $Timestamps{$r->{filename}};
}

1;
# ABSTRACT: Record timestamp of each module's loading (uses Time::HiRes)

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'timestamp::hires';
 # now each time we require(), the timestamp is recorded in %Require::HookChain::timestamp::hires::Timestamps

 # later, print out the timestamps
 for (sort keys %Require::HookChain::timestamp::hires::Timestamps) {
     print "Module $_ loaded at ", scalar(localtime $Require::HookChain::timestamp::hires::Timestamps{$_}), "\n";
 }


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::HookChain::timestamp::std> which uses built-in time() which only has
1-second granularity but does not require loading any module by itself.

L<Require::HookChain>
