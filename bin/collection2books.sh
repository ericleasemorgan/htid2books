#!/usr/bin/env bash

# collection2books.sh - given credential and a TSV file (collection), create a library of plain text and PDF files

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - done in a fit of creativity; "I get these every once in a while"


# configure
HTID2BOOKS='./bin/htid2books.sh'

# sanity check
if [[ -z $1 || -z $2 || -z $3 ]]; then
	echo "Usage: $0 <key> <secret> <tsv>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
TSV=$3

# initialize
I=0
IFS=$'\t'

# process each line in the tsv file
while read HTITEM_ID TITLE AUTHOR DATE RIGHTS OCLC LCCN ISBN CATALOG_URL HANDLE_URL; do

	# increment and skip first line
	let I=I+1; if [[ $I -eq 1 ]]; then continue; fi
		
	# make books
	$HTID2BOOKS $KEY $SECRET "$HTITEM_ID"
	
done < $TSV

# fini
exit
