#!/usr/bin/env bash

# htid2books.sh - given a key, secret, and HathiTrust identifier, output plain text and PDF files of books

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first cut


# configure
HTID2TXT='./bin/htid2txt.sh'
HTID2PDF='./bin/htid2pdf.sh'

# sanity check
if [[ -z $1 || -z $2 || -z $3 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
HTID=$3

# do the work and done; tricky
$HTID2TXT $KEY $SECRET $HTID
$HTID2PDF $KEY $SECRET $HTID $?
exit
