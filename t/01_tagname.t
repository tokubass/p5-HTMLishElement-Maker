use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

subtest 'simple_tag' => sub {
    my $anchor = htmlish('<a>');
    is($anchor->{is_single}, 0);
    is($anchor->print, '<a></a>');

    my $img = htmlish('<img/>');
    is($img->{is_single}, 1);
    is($img->print, '<img />');
};

subtest 'nested_tag' => sub {
    my $anchor = htmlish('<a>');
    $anchor->push('text');

    my $div = htmlish('<div>');
    $div->push($anchor);

    is($div->print, '<div><a>text</a></div>');
};

done_testing;

