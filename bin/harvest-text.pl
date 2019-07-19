#!/usr/bin/env perl

# htid2txt.pl - given some secrets and a HathiTrust identifier, output a plain (OCRed) text

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 10, 2019 - first cut
# February 16, 2019 - gonna call it done, but software is never finished
# July     14, 2019 - trapped for HTTP errors 401, 404, and 503

# configure
use constant REQUEST => 'https://babel.hathitrust.org/cgi/htd/volume/pageocr/';

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
my $url  = REQUEST . "$htid/$page";
my $done = 'false';

while( $done eq 'false' ) {

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
			params => { v => '2' }
		);

	# debug
	warn join( "\t", ( $htid, 'txt', $page, $response->code ) ), "\n";

	# output, conditionally and done
	if ( $response->code == '200' ) {

		print $response->content;
		exit( 1 );
	
	}

	# check for time-stamp error; re-try
	elsif ( $response->code == '401' ) { $done = 'false' }

	# check for file not found; signal exit
	elsif ( $response->code == '404' ) {
	
		$done      =  'true';
		my $output =  $htid ;
		$output    =~ s/\//-/g;
		`echo "$page" >> "./tmp/$output.txt"`;
		exit ( $page ) 
	
	}

	# system overloaded; rest
	elsif ( $response->code == '503' ) { $done = 'false'; sleep 2 }

	# error
	else { exit( 0 ) }

}
