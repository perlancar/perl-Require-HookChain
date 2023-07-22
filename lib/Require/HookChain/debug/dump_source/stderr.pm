## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::debug::dump_source::stderr;

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

sub Require::HookChain::debug::dump_source::stderr::INC {
    my ($self, $r) = @_;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    my $src = $r->src;
    return unless defined $src;

    warn "Require::HookChain::debug::dump_source::stderr: source code of ", $r->filename, " <<END_DUMP\n$src\nEND_DUMP\n";
}

1;
# ABSTRACT: Dump loaded source code to STDERR

=for Pod::Coverage .+

=head1 SYNOPSIS

 use Require::HookChain -end=>1,  'debug::dump_source::stderr';
 # now each time we require(), source code is printed to STDERR

A demo (L<nauniq> is a script available on CPAN):

 % PERL5OPT="-MRequire::HookChain=-end,1,debug::dump_source::stderr" nauniq ~/samples/1.csv
 Require::HookChain::debug::dump_source::stderr: source code of App/nauniq.pm <<END_DUMP
 ...
 END_DUMP
 Require::HookChain::debug::dump_source::stderr: source code of App/nauniq.pm <<END_DUMP
 ...
 END_DUMP
 ...


=head1 DESCRIPTION

This hook will do nothing if by the time it runs the source code is not yet
available, so make sure you put this hook at the end of C<@INC> using the C<<
-end => 1 >> option:

 use Require::HookChain -end=>1,  'debug::dump_source::stderr';


=head1 SEE ALSO

L<Require::HookChain::debug::dump_source::logger>

L<Require::HookChain>
