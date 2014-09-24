use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

subtest 'simple_attr' => sub {
    subtest 'single' => sub {
        my $anchor = htmlish('<a>');
        $anchor->add_attr(class => 'hoge');

        is($anchor->print, '<a class="hoge"></a>');

        $anchor->add_attr(class => 'foo');
        is($anchor->print, '<a class="hoge foo"></a>');
    };
    subtest 'multi' => sub {
        my $anchor = htmlish('<a>');
        $anchor->add_attr(class => [qw/hoge foo/]);
        is($anchor->print, '<a class="hoge foo"></a>');
    };
};


subtest 'custom_attr' => sub {
    subtest 'html_style' => sub {
        local $HTMLishElement::Maker::ATTR_SETTING = {
            style => 'key:val;',
        };
        my $anchor = htmlish('<a>');
        $anchor->add_attr(style => { color => 'red', display => 'block'});
        is($anchor->print, '<a style="color:red;display:block;"></a>');
    };
    subtest 'mystyle' => sub {
        local $HTMLishElement::Maker::ATTR_SETTING = {
            mystyle => 'key#val|',
        };
        my $anchor = htmlish('<a>');
        $anchor->add_attr(mystyle => { color => 'red', display => 'block'});
        is($anchor->print, '<a mystyle="color#red|display#block|"></a>');
    };
};


subtest 'bulk_set' => sub {
    my $anchor = htmlish('<a>');
    local $HTMLishElement::Maker::ATTR_SETTING = {  style => 'key:val;' };
    $anchor->add_attr(
        class => ['class1','class2'],
        id    => 'id1',
        style => { color => 'red', display => 'block'},
    );

    is($anchor->print, '<a class="class1 class2" id="id1" style="color:red;display:block;"></a>');


};

done_testing;

