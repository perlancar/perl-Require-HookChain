## no critic: TestingAndDebugging::RequireUseStrict
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

    my @caller = caller(1);
    my $elapsed = time() - $^T;
    warn "[time +${elapsed}s] Require::HookChain::log::stderr: Require-ing ".$r->filename." (called from package $caller[0] file $caller[1]:$caller[2]) ...\n";
}

1;
# ABSTRACT: Log a message to STDERR

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain 'log::stderr';
 # now each time we require(), a message is printed to STDERR

A demo (L<nauniq> is a Perl script you can get from CPAN):

 % PERL5OPT="-MRequire::HookChain=log::stderr" nauniq ~/samples/1.csv
 Require::HookChain::log::stderr: Require-ing strict.pm (called from package main file /home/u1/perl5/perlbrew/perls/perl-5.34.0/bin/nauniq:4) ...
 Require::HookChain::log::stderr: Require-ing warnings.pm (called from package main file /home/u1/perl5/perlbrew/perls/perl-5.34.0/bin/nauniq:5) ...
 Require::HookChain::log::stderr: Require-ing App/nauniq.pm (called from package main file /home/u1/perl5/perlbrew/perls/perl-5.34.0/bin/nauniq:7) ...
 Require::HookChain::log::stderr: Require-ing Getopt/Long.pm (called from package main file /home/u1/perl5/perlbrew/perls/perl-5.34.0/bin/nauniq:8) ...
 Require::HookChain::log::stderr: Require-ing vars.pm (called from package Getopt::Long file /loader/0x559d7b7578b0/Getopt/Long.pm:20) ...
 Require::HookChain::log::stderr: Require-ing warnings/register.pm (called from package vars file /loader/0x559d7b7578b0/vars.pm:7) ...
 Require::HookChain::log::stderr: Require-ing constant.pm (called from package Getopt::Long file /loader/0x559d7b7578b0/Getopt/Long.pm:220) ...
 Require::HookChain::log::stderr: Require-ing overload.pm (called from package Getopt::Long::CallBack file /loader/0x559d7b7578b0/Getopt/Long.pm:1574) ...
 Require::HookChain::log::stderr: Require-ing overloading.pm (called from package overload file /loader/0x559d7b7578b0/overload.pm:84) ...
 Require::HookChain::log::stderr: Require-ing Exporter/Heavy.pm (called from package Exporter file /home/u1/perl5/perlbrew/perls/perl-5.34.0/lib/5.34.0/Exporter.pm:13) ...
 ...


=head1 DESCRIPTION

This hook should be put at the beginning to be able to log before other hooks or
source loads the module, so it's best to require this hook last, e.g.:

 use Require::HookChain 'other::hook';
 use Require::HookChain 'other::hook2';
 ...
 use Require::HookChain 'log::stderr';

or:

 use Require::HookChain 'log::stderr';
 use Require::HookChain -end=>1, 'other::hook';
 use Require::HookChain -end=>1, 'other::hook2';
 ...


=head1 SEE ALSO

L<Require::HookChain::log::logger>

L<Require::HookChain>
