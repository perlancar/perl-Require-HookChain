## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::timestamp::std;

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

our %Timestamps; # key=module name, value=epoch

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub Require::HookChain::timestamp::std::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    $Timestamps{$r->filename} = time()
        unless defined $Timestamps{$r->{filename}};
}

1;
# ABSTRACT: Record timestamp of each module's loading

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'timestamp::std';
 # now each time we require(), the timestamp is recorded in %Require::HookChain::timestamp::std::Timestamps

 # later, print out the timestamps
 for (sort keys %Require::HookChain::timestamp::std::Timestamps) {
     print "Module $_ loaded at ", scalar(localtime $Require::HookChain::timestamp::std::Timestamps{$_}), "\n";
 }


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::HookChain::timestamp::hires> which uses L<Time::HiRes> to get
subsecond granularity but requires loading another module by itself.

L<Require::HookChain>
