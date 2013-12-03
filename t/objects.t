use strict;
use warnings;
use Test::More;
use RDF::aREF qw(decode_aref);

my @tests = (
    '@' => [ '', undef ],
    '' => [ '', undef ],
    '^xsd:string' => [ '', undef ],
    '^^xsd:string' => [ '', undef ],
    '^^<http://www.w3.org/2001/XMLSchema#string>' => [ '', undef ],
    '@^xsd:string' => [ '@', undef ],
    '@@' => [ '@', undef ],
    'alice@' => [ 'alice', undef ],
    'alice@en' => [ 'alice', 'en' ],
    'alice@example.com' => [ 'alice@example.com', undef ],
    '123' => [ '123', undef ],
    '123^xsd:integer' => [ '123', undef, "http://www.w3.org/2001/XMLSchema#integer" ],
    '123^^xsd:integer' => [ '123', undef, "http://www.w3.org/2001/XMLSchema#integer" ],
    '123^^<xsd:integer>' => [ '123', undef, "xsd:integer" ],
    '忍者@ja' => [ '忍者', 'ja' ],
    'Ninja@en@' => [ 'Ninja@en', undef ],
    'rdf:type' => [ 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' ],
    '<rdf:type>' => [ 'rdf:type' ],
    'geo:48.2010,16.3695,183' => [ 'geo:48.2010,16.3695,183' ],
    'geo:Point' => [ 'http://www.w3.org/2003/01/geo/wgs84_pos#Point' ],
);

while (defined (my $input = shift @tests)) {
    my ($expect, $object, $error) = shift @tests;
    decode_aref 
        { '<x:subject>' => { '<x:predicate>' => $input } },
        callback => sub { shift; shift; $object = \@_; },
        error    => sub { $error = shift };
    is_deeply $object, $expect, "\"$input\"";
}

done_testing;