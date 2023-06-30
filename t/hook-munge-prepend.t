#!perl

use strict;
use warnings;
use FindBin '$Bin';
use Test::More 0.98;

{
    # remove all hooks first
    local @INC = grep { !ref } @INC;
    unshift @INC, "$Bin/lib";
    require Require::HookChain;
    Require::HookChain->import("munge::prepend", 'our $main::foo=2;');

    undef $main::foo;
    require Local::Foo;
    diag explain \%INC;
    is($main::foo, 2);
}
