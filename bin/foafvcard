#!/usr/bin/perl

# A little perl script to produce foaf::Person from vCards.
#
# Written by Kjetil Kjernsmo, kjetilk@cpan.org, 2004-10-19
# License: Same terms as Perl itself. 

use XML::FOAFKnows::FromvCard;

my $file;
my $seeAlsoUri;
my $myUri;
my $myEmail; 


foreach my $clp (@ARGV) {
  if ($clp =~ m/^--seeAlso=(\S+)$/) {
    $seeAlsoUri = $1;
  } elsif ($clp =~ m/^--uri=(\S+)$/) {
    $myUri = $1;
  } elsif ($clp =~ m/^--email=(\S+)$/) {
    $myEmail = $1;
  } else {
    $file = $clp;
  }
}

unless ($file) {
  print 'Usage: [--seeAlso=URI|--uri=URI|--email=your@email.address] file' . "\n";
  exit(1);
}

open(VCF, "< ". $file) || die "Cannot open $file";
my @data = <VCF>;
close VCF;



my $formatter = XML::FOAFKnows::FromvCard->format(join('',@data), (uri => $myUri, seeAlso => $seeAlsoUri, email => $myEmail));
print $formatter->document('UTF-8');
