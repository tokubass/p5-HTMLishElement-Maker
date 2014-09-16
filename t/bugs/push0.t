use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

subtest 'push 0' => sub {
    my $anchor = htmlish('<a>');
    $anchor->push(0);
   is($anchor->print,'<a>0</a>');
};

done_testing;
