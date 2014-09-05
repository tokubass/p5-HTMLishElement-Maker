package HTMLishElement::Maker;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";


1;
__END__

=encoding utf-8

=head1 NAME

HTMLishElement::Maker - XXX

=head1 SYNOPSIS

    use HTMLishElement::Maker;
    local $HTMLishElement::Maker::ATTR_SETTING = {
        style => {
            key_value_sep  => ':', # optional
            end => ';'  # default ' '
        }
    };

    HTMLishElement::Maker->new('<hoge>');# <hoge></hoge>
    HTMLishElement::Maker->new('<hoge/>');# <hoge/>

    my $anchor = HTMLishElement::Maker->new('<a>');# <a></a>
    $anchor->push('text'); # <a>text</a>
    $anchor->add_attr(class => 'hoge'); # <a class="hoge">text</a>
    $anchor->add_attr(class => [qw/ foo bar /] ); # <a class="hoge foo bar">text</a>
    $anchor->reset_attr('class'); #<a>text</a>

    $anchor->add_attr(style => { color => 'red', display => 'block'}); # <a style="color:red;display:block;">text</a>
    $anchor->reset_attr; #remove all attr

    my $div = HTMLishElement::Maker->new('<div>');
    $div->push($anchor); #<div><a>text</a></div>

    my $str = $div->print;

=head1 DESCRIPTION

HTMLishElement::Maker is ...

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass E<lt>tokubass@cpan.orgE<gt>

=cut

