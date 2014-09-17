# NAME

HTMLishElement::Maker - make only html-like tag. escape and encode are not performed.

# SYNOPSIS

    use HTMLishElement::Maker qw/htmlish/;

    htmlish('<hoge>');# <hoge></hoge>
    htmlish('<hoge/>');# <hoge/>

    my $anchor = htmlish('<a>');# <a></a>
    $anchor->push('text'); # <a>text</a>
    $anchor->add_attr(class => 'hoge'); # <a class="hoge">text</a>
    $anchor->add_attr(class => [qw/ foo bar /] ); # <a class="hoge foo bar">text</a>
    $anchor->reset_attr('class'); #<a>text</a>

    local $HTMLishElement::Maker::ATTR_SETTING = {
            style => 'key:val;',
            mystyle => 'key#val|',
        }
    };
    $anchor->add_attr(style => { color => 'red', display => 'block'}); # <a style="color:red;display:block;">text</a>
    $anchor->add_attr(mystyle => { color => 'red', display => 'block'}); # <a style="color:red;display:block;" mystyle="color#red|display#block|">text</a>
    $anchor->reset_attr; #remove all attr

    my $div = htmlish('<div>');
    $div->push($anchor); #<div><a>text</a></div>

    my $str = $div->print;

# LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokubass <tokubass@cpan.org>
