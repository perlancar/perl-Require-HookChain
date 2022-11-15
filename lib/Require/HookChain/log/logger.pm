package Require::HookChain::log::logger;

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub Require::HookChain::log::logger::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    log_trace "Require::HookChain::log::logger: Require-ing %s ...", $r->filename;
}

1;
# ABSTRACT: Log a message to Log::ger

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'log::ger';
 # now each time we require(), a logging statement is produced at the trace level

A demo (L<nauniq> is a Perl script you can get from CPAN, and
L<Log::ger::Screen> is a module to show log statements on the terminal):

 $ TRACE=1 PERL5OPT="-MLog::ger::Screen -MRequire::HookChain=log::logger" nauniq ~/samples/1.csv
 Require::HookChain::log::logger: Require-ing App/nauniq.pm ...
 Require::HookChain::log::logger: Require-ing Getopt/Long.pm ...
 Require::HookChain::log::logger: Require-ing vars.pm ...
 Require::HookChain::log::logger: Require-ing warnings/register.pm ...
 Require::HookChain::log::logger: Require-ing constant.pm ...
 Require::HookChain::log::logger: Require-ing overload.pm ...
 Require::HookChain::log::logger: Require-ing overloading.pm ...
 Require::HookChain::log::logger: Require-ing Exporter/Heavy.pm ...
 ...


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::HookChain::log::stderr>

L<Require::HookChain>
