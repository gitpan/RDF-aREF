use strict;
package RDF::aREF;
#ABSTRACT: Another RDF Encoding Form
our $VERSION = '0.04'; #VERSION

use RDF::aREF::Decoder;

use parent 'Exporter';
our @EXPORT = qw(decode_aref);
our @EXPORT_OK = qw(aref_to_trine_statement decode_aref);

# TODO: test this
sub aref_to_trine_statement {
    require RDF::Trine::Statement;

    RDF::Trine::Statement->new(
        # subject
        ref $_[0] ? RDF::Trine::Node::Blank->new(${$_[0]})
            : RDF::Trine::Node::Resource->new($_[0]),
        # predicate
        RDF::Trine::Node::Resource->new($_[1]),
        # object
        do {
            if (ref $_[2]) {
                RDF::Trine::Node::Blank->new(${$_[2]});
            } elsif (@_ == 3) {
                RDF::Trine::Node::Resource->new($_[2]);
            } else {
                RDF::Trine::Node::Literal->new($_[2],$_[3],$_[4]);
            } 
        }
    );
}

sub decode_aref(@) { ## no critic
    my ($aref, %options) = @_;
    RDF::aREF::Decoder->new(%options)->decode($aref);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

RDF::aREF - Another RDF Encoding Form

=head1 VERSION

version 0.04

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

=head1 DESCRIPTION

This module decodes B<another RDF Encoding Form (aREF)> to RDF triples.

=head1 EXPORTED FUNCTIONS

=head2 decode_aref ( $aref, [ %options ] )

Decodes an aREF document given as hash referece. Options are passed to the
constructor of L<RDF::aREF::Decoder>.

=head1 SEE ALSO

=over

=item

This module was first packaged together with L<Catmandu::RDF>.

=item

aREF is being specified at L<http://github.com/gbv/aREF>.

=item

See L<RDF::YAML> for an outdated similar RDF encoding in YAML.

=back

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
