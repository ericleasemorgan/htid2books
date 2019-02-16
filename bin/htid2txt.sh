#!/usr/bin/env bash

# htid2txt.sh - given a key, secret, and HathiTrust identifier, build a plain text file; a front-end to htid2txt.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation


# configure
HTID2TXT='./bin/htid2txt.pl'
PAGES='./pages'
BOOKS='./books'

# sanity check
if [[ -z $1 || -z $2 || -z $3 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
HTID=$3

# initialize
CONTINUE=1
PAGE=0

# make sane
mkdir -p $PAGES
mkdir -p $BOOKS
rm -rf $PAGES/*.txt

# repeatedly get content
while [[ $CONTINUE -gt 0 ]]; do

	# increment and get content
	let PAGE=PAGE+1 
	CONTENT=$( $HTID2TXT $KEY $SECRET $HTID $PAGE )
	
	# capture exit code
	CONTINUE=$?
	
	# check for success
	if [[ $CONTINUE -gt 0 ]]; then
	
		# output content
		ITEM=$( printf "%04d" $PAGE )
		printf %q "$CONTENT" > "$PAGES/page-$ITEM.txt"
	
	fi
		
done

# build the book and output
BOOK=$( cat $PAGES/*.txt )
printf %q "$BOOK" > $BOOKS/$HTID.txt

# calculate length of book and return it; done
let LEGNTH=PAGE-1 
exit $LEGNTH

