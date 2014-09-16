use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

sub _init {
    local $HTMLishElement::Maker::ATTR_SETTING = {
        style => 'key:val;',
    };
    my $anchor = htmlish('<a>');
    $anchor->add_attr(style => { color => 'red', display => 'block'});
    $anchor->add_attr(class => 'hoge');
    return $anchor;
}

subtest 'reset' => sub {
    my $anchor = _init;
    $anchor->reset_attr('style');
    is($anchor->print, '<a class="hoge"></a>');
};


subtest 'all_reset' => sub {
    my $anchor = _init;
    $anchor->reset_attr;
    is($anchor->print, '<a></a>');
};


done_testing;

