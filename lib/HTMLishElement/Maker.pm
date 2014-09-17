package HTMLishElement::Maker;
use 5.008005;
use strict;
use warnings;
use Carp;
use Sub::Recursive qw/recursive $REC/;
use Exporter qw/import/;
our $VERSION = "0.01";

our @EXPORT_OK = qw/htmlish/;
our $ATTR_SETTING = {};

sub new {
    my ($class, $tag_name) = @_;

    croak 'invalid tag_name' unless $tag_name =~ m!\A<([^/?]+)(/?)>\z!;

    my $self = bless {
        tag => $1,
        value => '',
        attr => {},
        is_single => $2 ? 1 : 0,
        children => [],
    } => $class;
}


sub htmlish {
    __PACKAGE__->new(shift);
}

sub children { @{ shift->{children} || [] } }

sub push {
    my $self = shift;
    my $elem = shift;
    $elem = '' if (!defined $elem);

    if ( ref($elem) eq ref($self) ) {
        push @{$self->{children}}, $elem;
    }elsif( !ref($elem) ) {
        $self->push( bless { tag => 'text', value => $elem } => ref $self );
    }

    return $self;
}

sub add_attr {
    my $self = shift;
    my $attr_name = shift  or die 'please input attribute name';
    my $attr_val = shift or die 'please input attribute value';

    # class="hoge"
    if ( !ref($attr_val) ) {
        $self->{attr}{$attr_name} ||= [];
        CORE::push(@{$self->{attr}{$attr_name}}, $attr_val);
    }
    # class="hoge foo"
    elsif( ref($attr_val) eq 'ARRAY') {
        $self->{attr}{$attr_name} ||= [];
        CORE::push(@{$self->{attr}{$attr_name}}, @$attr_val);
    }
    # style="color:red;"
    elsif( ref($attr_val) eq 'HASH') {
        $self->{attr}{$attr_name} = $attr_val;
    }
}


sub print {
    my $self = shift;

    my $builder = recursive {
        my $maker = shift;
        my @processed_children;
        for my $child ($maker->children) {
            my $ret = $REC->($child);
            CORE::push @processed_children, $ret;
        }
        return $maker->_get_string( join('' => @processed_children) );
    };

    return $builder->($self);
}

sub _get_string {
    my $self = $_[0];
    my $inner_elem = defined $_[1] ? $_[1] : '';
    my $tag = $self->{tag};
    my $attr = $self->_build_attr;

    return "<$tag$attr />$inner_elem" if $self->{is_single};

    if ($self->{tag} eq 'text') {
        return $self->{value} . $inner_elem;
    }

    return  "<$tag$attr>$inner_elem</$tag>";
}

sub _build_attr {
    my $self = shift;

    my $res = '';
    for my $attr_name ( sort keys %{$self->{attr}} ) {
        next unless (my $attr_value = $self->{attr}{$attr_name});

        my $value_str = '';
        if (ref $attr_value eq 'HASH') {
            my $setting = $HTMLishElement::Maker::ATTR_SETTING->{$attr_name};
            if ($setting && $setting =~ m/key(.)val(.)/) {
                my @list;
                for my $key (sort keys %$attr_value) {
                    CORE::push @list, join('' => $key, $1, $attr_value->{$key}, $2);
                }
                $value_str = join('', @list);
            }
        }else{
            $value_str = join(' ', @{$attr_value} );
        }
        $res .= sprintf(' %s="%s"', $attr_name, $value_str);
    }
    return $res;
}

sub reset_attr {
    my $self = shift;
    my $key = shift;

    if ($key) {
        $self->{attr}{$key} = undef;
    }else{
        $self->{attr} = {}
    }
}


1;

__END__

=encoding utf-8

=head1 NAME

HTMLishElement::Maker - make only html-like tag. escape and encode are not performed.

=head1 SYNOPSIS

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

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass E<lt>tokubass@cpan.orgE<gt>

=cut

