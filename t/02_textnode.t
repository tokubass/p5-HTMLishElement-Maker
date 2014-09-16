use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

subtest 'push_text' => sub {
    my $anchor = htmlish('<a>');
    $anchor->push('text');
    is($anchor->print, '<a>text</a>');
    $anchor->push('2text3');
    is($anchor->print, '<a>text2text3</a>');
};

done_testing;
