use Test::More;
use strict;
use warnings;
use HTMLishElement::Maker qw/htmlish/;
use Data::Dumper;

subtest 'table' => sub {
    my $table = htmlish('<table>');
    my $tbody = htmlish('<tbody>');
    my $tr    = htmlish('<tr>');

    $table->push($tbody);
    $tbody->push($tr);

    for my $text ( qw/aa bb cc/ ) {
        $tr->push( htmlish('<td>')->push($text) );
    }

    is($table->print, '<table><tbody><tr><td>aa</td><td>bb</td><td>cc</td></tr></tbody></table>');
};

done_testing;
