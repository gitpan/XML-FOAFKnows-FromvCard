use strict;
use warnings;
use Test::More tests => 6;

use_ok ('XML::FOAFKnows::FromvCard');


my $data = <<'_EOD_';
BEGIN:VCARD
CLASS:PRIVATE
EMAIL:foobar@example.invalid
FN:Foo Bar
N:Bar;Foo;;;
UID:rpyKXuQx9J
URL:http://www.foobar.org/
VERSION:3.0
END:VCARD

BEGIN:VCARD
CLASS:PUBLIC
EMAIL:john.smith@example.invalid
FN:John Smith
N:Smith;John;;;
UID:yiLst2xaHn
URL:http://www.smith.invalid.uk/
VERSION:3.0
END:VCARD

_EOD_

my $fragexpected = <<'_EOD_';
<foaf:knows>
	<foaf:Person rdf:nodeID="person1">
		<foaf:mbox_sha1sum>fd6daac7036c77f48a3803b706e06a963b27de56</foaf:mbox_sha1sum>
		<foaf:homepage rdf:resource="http://www.foobar.org/"/>
	</foaf:Person>
</foaf:knows>
<foaf:knows>
	<foaf:Person rdf:nodeID="person2">
		<foaf:mbox_sha1sum>47d56eaaf12f1686e4d59612507ab42a08c22145</foaf:mbox_sha1sum>
		<foaf:homepage rdf:resource="http://www.smith.invalid.uk/"/>
		<foaf:family_name>Smith</foaf:family_name>
		<foaf:givenname>John</foaf:givenname>
		<foaf:name>John Smith</foaf:name>
	</foaf:Person>
</foaf:knows>
_EOD_



my $docexpected = <<'_EOD_';
<?xml version="1.0"?>
<rdf:RDF
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
<foaf:Person rdf:about="http://search.cpan.org/~kjetilk/#fictious">
	<foaf:mbox_sha1sum>118e4bc7a8668b31b71e2b53173e627b66fe8f62</foaf:mbox_sha1sum>
	<rdfs:seeAlso rdf:resource="http://www.kjetil.kjernsmo.net/foaf.rdf"/>

<foaf:knows>
	<foaf:Person rdf:nodeID="person1">
		<foaf:mbox_sha1sum>fd6daac7036c77f48a3803b706e06a963b27de56</foaf:mbox_sha1sum>
		<foaf:homepage rdf:resource="http://www.foobar.org/"/>
	</foaf:Person>
</foaf:knows>
<foaf:knows>
	<foaf:Person rdf:nodeID="person2">
		<foaf:mbox_sha1sum>47d56eaaf12f1686e4d59612507ab42a08c22145</foaf:mbox_sha1sum>
		<foaf:homepage rdf:resource="http://www.smith.invalid.uk/"/>
		<foaf:family_name>Smith</foaf:family_name>
		<foaf:givenname>John</foaf:givenname>
		<foaf:name>John Smith</foaf:name>
	</foaf:Person>
</foaf:knows>

</foaf:Person>
</rdf:RDF>
_EOD_

my $text = XML::FOAFKnows::FromvCard->format($data, 
					     (uri => 'http://search.cpan.org/~kjetilk/#fictious', 
					      seeAlso => 'http://www.kjetil.kjernsmo.net/foaf.rdf', 
					      email => 'kjetilk@cpan.org'));

isa_ok( $text, 'XML::FOAFKnows::FromvCard' );

ok($text->fragment eq $fragexpected, 'Fragment comes out as expected');

ok($text->document eq $docexpected, 'Document comes out as expected');


ok(my $links = $text->links, 'Assigning links');

my $expectedlinks = [
		     {
		      'title' => 'John Smith',
		      'uri' => 'http://www.smith.invalid.uk/'
		     }
		    ];

ok(eq_array($expectedlinks, $links), 'All links and titles match');
