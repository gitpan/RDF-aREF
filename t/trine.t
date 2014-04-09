use strict;
use Test::More;
use RDF::aREF;

BEGIN {
    eval { 
        require RDF::Trine::Model; 
        1; 
    } or do {
        plan skip_all => "RDF::Trine required";
    };
}

my $model = RDF::Trine::Model->new;

decode_aref( {
        _id => 'http://example.org/alice',
        a => 'foaf:Person',
        foaf_knowns => 'http://example.org/bob'
    }, 
    callback => $model,
);
is $model->size, 2, 'added two statements';

decode_aref( {
        _id => 'http://example.org/alice',
        a => 'foaf:Person',
        foaf_knowns => 'http://example.org/claire'
    },
    callback => $model,
);
is $model->size, 3, 'added another statement';

# bnodes
$model = RDF::Trine::Model->new;
my $decoder = RDF::aREF::Decoder->new( callback => $model );
my $aref = { _id => '<x:subject>', foaf_knows => { foaf_name => 'alice' } }; 
$decoder->decode( $aref );
$decoder->decode( $aref );
is $model->size, 4, 'no bnode collision';
is $decoder->bnode_count, 2;
$decoder->bnode_count(1);
$decoder->decode( $aref );
is $model->size, 4, 'bnode collision';

# errors
my $error;
decode_aref( {
        _id => 'isbn:123', 
        rdfs_seeAlso => [
            'isbn:456 x',  # looks like an IRI to aREF but rejected by Trine
            'isbn:789'
        ]
    }, 
    callback => $model, error => sub { $error = shift }
);
ok $error, "bad IRI";
is $model->size, 5, 'ignored illformed URI';


done_testing;
