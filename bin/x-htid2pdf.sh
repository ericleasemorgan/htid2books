#!/usr/bin/env bash

# htidpdf.pl - given a key, secret, HathiTrust identifier, and length, output a PDF file; a front-end to htid2pdf.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation


# configure
HTID2PDF='./bin/htid2pdf.pl'
PAGES='./pages'
BOOKS='./books'

# sanity check
if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier> <length>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
HTID=$3
LEGNTH=$4

# initialize
CONTINUE=1
PAGE=0

# make sane
mkdir -p $PAGES
mkdir -p $BOOKS
rm -rf $PAGES/*.png

# repeatedly get content
while [[ $CONTINUE -gt 0 ]]; do

	# trap bug; break if got enough pages
	if [[ $PAGE -eq $LEGNTH ]]; then break; fi

	# increment and get content
	let PAGE=PAGE+1 
	ITEM=$( printf "%04d" $PAGE )
	$HTID2PDF $KEY $SECRET $HTID $PAGE > "$PAGES/page-$ITEM.png"
	
	# capture exit code; cool!
	CONTINUE=$?
		
done

# build pdf and done
convert $PAGES/*.png $BOOKS/$HTID.pdf
exit

