use strict;
use warnings;
package RDF::aREF;
#ABSTRACT: Another RDF Encoding Form
our $VERSION = '0.11'; #VERSION

use RDF::aREF::Decoder;

use parent 'Exporter';
our @EXPORT = qw(decode_aref);
our @EXPORT_OK = qw(aref_to_trine_statement decode_aref);

sub decode_aref(@) { ## no critic
    my ($aref, %options) = @_;
    RDF::aREF::Decoder->new(%options)->decode($aref);
}

sub aref_to_trine_statement {
    # TODO: warn 'RDF::aREF::aref_to_trine_statement will be removed!';
    RDF::aREF::Decoder::aref_to_trine_statement(@_);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

RDF::aREF - Another RDF Encoding Form

=head1 VERSION

version 0.11

=head1 SYNOPSIS

    use RDF::aREF;

    my $rdf = {
      _id       => 'http://example.com/people#alice',
      foaf_name => 'Alice Smith',
      foaf_age  => '42^xsd:integer',
      foaf_homepage => [
         { 
           _id => 'http://personal.example.org/',
           dct_modified => '2010-05-29^xsd:date',
         },
        'http://work.example.com/asmith/',
      ],
      foaf_knows => {
        dct_description => 'a nice guy@en',
      },
    };

    decode_aref( $rdf,
        callback => sub {
            my ($subject, $predicate, $object, $language, $datatype) = @_;
            ...
        }
    );
    
    my $model = RDF::Trine::Model->new;
    decode_aref( $rdf, callback => $model );
    print RDF::Trine::Serializer->new('Turtle')->serialize_model_to_string($model);

=head1 DESCRIPTION

aREF (L<another RDF Encoding Form|http://gbv.github.io/aREF/>) is an encoding
of RDF graphs in form of arrays, hashes, and Unicode strings. This module 
implements decoding from aREF data to RDF triples.

=head1 EXPORTED FUNCTIONS

=head2 decode_aref ( $aref, [ %options ] )

Decodes an aREF document given as hash referece. This function is a shortcut for

    RDF::aREF::Decoder->new(%options)->decode($aref)

See L<RDF::aREF::Decoder> for possible options.

=head1 SEE ALSO

=over

=item

This module was first packaged together with L<Catmandu::RDF>.

=item

aREF is being specified at L<http://github.com/gbv/aREF>.

=item

L<RDF::Trine> contains much more for handling RDF data in Perl.

=item

See L<RDF::YAML> for a similar (outdated) RDF encoding in YAML.

=back

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
