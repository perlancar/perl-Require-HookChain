package Require::HookChain::log::stderr;

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

sub Require::HookChain::log::stderr::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    warn "Require::HookChain::log::stderr: Require-ing ".$r->filename." ...\n";
}

1;
# ABSTRACT: Log a message to STDERR

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'log::stderr';
 # now each time we require(), a message is printed to STDERR

A demo (L<nauniq> is a Perl script you can get from CPAN):

 % PERL5OPT="-MRequire::HookChain=log::stderr" nauniq ~/samples/1.csv
 Require::HookChain::log::stderr: Require-ing App/nauniq.pm ...
 Require::HookChain::log::stderr: Require-ing Getopt/Long.pm ...
 Require::HookChain::log::stderr: Require-ing vars.pm ...
 Require::HookChain::log::stderr: Require-ing warnings/register.pm ...
 Require::HookChain::log::stderr: Require-ing constant.pm ...
 Require::HookChain::log::stderr: Require-ing overload.pm ...
 Require::HookChain::log::stderr: Require-ing overloading.pm ...
 Require::HookChain::log::stderr: Require-ing Exporter/Heavy.pm ...
 ...


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::HookChain::log::logger>

L<Require::HookChain>
