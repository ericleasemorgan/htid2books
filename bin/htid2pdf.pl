#!/usr/bin/env perl

# htid2pdf.pl - given a HathiTrust identifier, output a PDF file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first cut


# configure
use constant REQUEST => 'https://babel.hathitrust.org/cgi/htd/volume/pageimage/';

# require
use strict;
use OAuth::Lite::Consumer;
use OAuth::Lite::AuthMethod;

# get input
my $key    = $ARGV[ 0 ];
my $secret = $ARGV[ 1 ];
my $htid   = $ARGV[ 2 ];
my $page   = $ARGV[ 3 ];
if ( ! $key | ! $secret | ! $htid | ! $page ) { die "Usage: $0 <key> <secret> <htid> <page>\n" }

# initialize
my $url = REQUEST . "$htid/$page";

# authenticate
my $consumer = OAuth::Lite::Consumer->new(
		consumer_key    => $key,
		consumer_secret => $secret,
		auth_method     => OAuth::Lite::AuthMethod::URL_QUERY,
	);

# request
my $response = $consumer->request(
		method => 'GET',
		url    => $url,
		params => { v => '2', format => 'png' }
	);

# debug
warn join( "\t", ( $page, $response->code ) ), "\n";

# success; output content and signal more
if ( $response->code == '200' ) {

	print $response->content;
	exit( 1 );
	
}

# error
else { exit( 0 ) }

