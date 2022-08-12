#!/usr/bin/env perl

# harvest-text.pl - given some secrets and a HathiTrust identifier, output a plain (OCRed) text

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 10, 2019 - first cut
# February 16, 2019 - gonna call it done, but software is never finished
# July     14, 2019 - trapped for HTTP errors 401, 404, and 503
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff
 
# configure
use constant REQUEST => 'https://babel.hathitrust.org/cgi/htd/volume/pageocr/';
use constant KEY     => $ENV{'HTKEY'};
use constant SECRET  => $ENV{'HTSECRET'};

# require
use strict;
use OAuth::Lite::Consumer;
use OAuth::Lite::AuthMethod;

# get input
my $htid = $ARGV[ 0 ];
my $page = $ARGV[ 1 ];
if ( ! $htid | ! $page ) { die "Usage: $0 <htid> <page>\n" }

# sanity checks
if ( ! KEY )    { die "The environment variable named HTKEY is not defined. Call Eric.\n" }
if ( ! SECRET ) { die "The environment variable named HTSECRET is not defined. Call Eric.\n" }

# initialize
my $url  = REQUEST . "$htid/$page";
my $done = 'false';
binmode( STDOUT, ':utf8' );
$| = 1;

# work forever, sort of
while( $done eq 'false' ) {

	# authenticate
	my $consumer = OAuth::Lite::Consumer->new(
			consumer_key    => KEY,
			consumer_secret => SECRET,
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

		print $response->decoded_content;
		exit( 1 );
	
	}

	# check for time-stamp error; re-try
	elsif ( $response->code == '401' ) { $done = 'false'; sleep 2 }

	# check for too many requests; re-try
	elsif ( $response->code == '429' ) { $done = 'false'; sleep 2 }

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
