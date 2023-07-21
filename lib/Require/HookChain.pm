## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain;

# AUTHORITY
# DATE
# DIST
# VERSION

#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

# be minimalistic, use our own blessed() so we don't have to load any module (in this case, Scalar::Util)
unless (defined &blessed) {
    *blessed = sub { my $arg = shift; my $ref = ref $arg; $ref && $ref !~ /\A(SCALAR|ARRAY|HASH|GLOB|Regexp)\z/ };
}

our $debug;

my $our_hook; $our_hook = sub {
    my ($self, $filename) = @_;

    warn "[Require::HookChain] require($filename) ...\n" if $debug;

    my $r = Require::HookChain::r->new(filename => $filename);

    for my $item (@INC) {
        my $ref = ref $item;

        if (!$ref) {
            # load from ordinary file
            next if defined $r->src;

            my $path = "$item/$filename";
            if (-f $path) {
                warn "[Require::HookChain] Loading $filename from $path ...\n" if $debug;
                open my $fh, "<", $path
                    or die "Can't open $path: $!";
                local $/;
                $r->src(scalar <$fh>);
                close $fh;
                next;
            }
        } elsif ($ref =~ /\ARequire::HookChain::(.+)/) {
            warn "[Require::HookChain] Calling hook $1 ...\n" if $debug;
            # currently return value is ignored
            $item->INC($r);
        }
    }

    my $src = $r->src;
    if (defined $src) {
        return \$src;
    } else {
        die "Can't locate $filename in \@INC";
    }
};

sub import {
    my $class = shift;

    # get early options first (-debug)
    {
        my $i = -1;
        while ($i < @_) {
            $i++;
            if ($_[$i] eq '-debug') {
                $debug = $_[$i+1];
                $i++;
                next;
            } elsif ($_[$i] =~ /\A-/) {
                $i++;
                next;
            } else {
                last;
            }
        }
    }

    warn "[Require::HookChain] (Re-)installing our own hook at the beginning of \@INC ...\n"
        if $debug;
    unless (@INC && blessed($INC[0]) && $INC[0] == $our_hook) {
        @INC = ($our_hook, grep { !(blessed($_) && $_ == $our_hook) } @INC);
    }

    # get the rest of the options and hook
    my $end;
    while (@_) {
        my $el = shift @_;
        if ($el eq '-end') {
            $end = shift @_;
            next;
        } elsif ($el eq '-debug') {
            # we've processed this
            shift @_;
            next;
        } else {
            my $pkg = "Require::HookChain::$el";
            (my $pkg_pm = "$pkg.pm") =~ s!::!/!g;
            warn "[Require::HookChain] Installing hook $el to the ".($end ? "end":"beginning")." of \@INC, args (".join(",", @_).") ...\n"
                if $debug;
            require $pkg_pm;
            my $c_hook = $pkg->new(@_);
            if ($end) {
                push @INC, $c_hook;
            } else {
                splice @INC, 1, 0, $c_hook;
            }
            last;
        }
    }
}

package Require::HookChain::r;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub filename {
    my $self = shift;
    $self->{filename};
}

sub src {
    my $self = shift;
    if (@_) {
        my $old = $self->{src};
        $self->{src} = shift;
        return $old;
    } else {
        return $self->{src};
    }
}

1;
# ABSTRACT: Chainable require hooks

=for Pod::Coverage ^(blessed)$

=head1 SYNOPSIS

Say you want to create a require hook to prepend some code to the module source
code that is loaded. In your hook source, in
F<Require/HookChain/munge/prepend.pm>:

 package Require::HookChain::munge::prepend;

 sub new {

     # our hook accepts one argument: preamble (the string to be prepended)
     my ($class, $preamble) = @_;

     bless { preamble => $preamble }, $class;
 }

 sub Require::HookChain::munge::prepend::INC {

     # instead a filename like a reguler hook, an hook's INC is called by
     # Require::HookChain's main INC and will be passed $r stash
     my ($self, $r) = @_;

     # safety, in case we are not called by Require::HookChain
     return () unless ref $r;

     my $src = $r->src;

     # we only munge source code, when source code has not been loaded by other
     # hooks, we decline.
     return unless defined $src;

     $src = "$self->{preamble};\n$src";
     $r->src($src);
 }

 1;

In a code to use this hook:

 use Require::HookChain 'munge::prepend' => 'use strict';
 use Foo::Bar; # Foo/Bar.pm will be loaded with added 'use strict;' at the start

Install other hooks, but put it at the end of C<@INC> instead of at the
beginning:

 use Require::HookChain -end => 1, append => 'some code';
 use Require::HookChain 'log::stderr'; # log each loading of module to stderr


=head1 DESCRIPTION

This module lets you create chainable require hooks. As one already understands,
Perl lets you put a coderef or object in C<@INC>. In the case of object, its
C<INC> method will be called by Perl:

 package My::INCHandler;
 sub new { ... }
 sub My::INCHandler::INC {
     my ($self, $filename) = @_;
     ...
 }

The method is passed itself then filename (which is what is passed to
C<require()>) and is expected to return nothing or a list of up to four values:
a scalar reference containing source code, filehandle, reference to subroutine,
optional state for subroutine (more information can be read from the L<perlfunc>
manpage). As soon as the first hook in C<@INC> returns non-empty value then the
search for source code is stopped.

With C<Require::HookChain>, you can put multiple hooks in C<@INC> that all get
executed. When C<use>'d, C<Require::HookChain> will install its own hook at the
beginning of C<@INC> which will search for source code in C<@INC> as well as
execute C<INC> method of all the other hooks which are instances of
C<Require::HookChain::*> class. Instead of filename, the method is passed a
C<Require::HookChain::r> object (C<$r>). The method can do things on C<$r>, for
example retrieve source code via C<< $r->src >> or modify source code via C<<
$r->src($new_content) >>. After the method returns, the next
C<Require::HookChain::*> hook is executed, and so on. The final source code will
be retrieved from C<< $r->src >> and returned for Perl.

This lets one chainable hook munge the result of the previous chainable hook.

To create your own chainable require hook, see example in L</"SYNOPSIS">. First
you create a module under the C<Require::HookChain::*> namespace, then create a
constructor as well as C<INC> handler.

=head2 Import options

Options must be specified at the beginning, before specifying

=over

=item * -end

Bool. If set to true, then hooks will be put at the end of C<@INC> instead of at
the beginning (after Require::HookChain's own hook). Regardless,
Require::HookChain's own hook will be put at the beginning to allow executing
all the other hooks.

=item * -debug

Bool. If set to true, then debug messages will be printed to stderr.

=back


=head2 Subnamespace organization

=over

=item * Require::HookChain::debug::

Hooks that do debugging-related stuffs. See also: C<log::> subnamespace,
C<timestamp::> subnamespace.

=item * Require::HookChain::filter::

Hooks that filter module loading due to some criteria. These hooks can fail a
module being loaded even though the source is available, if the additional
criteria are not met.

=item * Require::HookChain::log::

Hooks that add logging to module loading process. See also: C<debug::>
subnamespace.

=item * Require::HookChain::munge::

Hooks that modify source code.

=item * Require::HookChain::source::

Hooks that allow loading module source from alternative sources.

=item * Require::HookChain::test::

Testing-related, particularly testing the Require::HookCHain hook module itself.

=item * Require::HookChain::timestamp::

Hooks that add timestamps during module loading process.

=back


=head1 Require::HookChain::r OBJECT

=head2 Methods

=head3 filename

Usage:

 my $filename = $r->filename;

=head3 src

Usage:

 my $src = $r->src;
 $r->src($new_src);

Get or set source code content. Will return undef if source code has not been
found or set.


=head1 FAQ

=head2 Loading a hook does nothing!

Make sure you use a hook this way:

 use Require::HookChain 'hookname'; # correct

instead of:

 use Require::HookChain::hookname; # INCORRECT


=head1 SEE ALSO

L<RHC> for convenience of using on the command-line or one-liners.
