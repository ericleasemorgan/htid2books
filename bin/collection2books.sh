#!/usr/bin/env bash

# collection2books.sh - given credential and a TSV file (collection), create a library of plain text and PDF files

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - done in a fit of creativity; "I get these every once in a while"
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff


# configure
HTID2BOOKS='./bin/htid2books.sh'

# sanity check
if [[ -z $1  ]]; then
	echo "Usage: $0 <tsv>" >&2
	exit
fi

# get input
TSV=$1

# initialize
I=0
IFS=$'\t'

# process each line in the tsv file
while read HTITEM_ID TITLE AUTHOR DATE RIGHTS OCLC LCCN ISBN CATALOG_URL HANDLE_URL; do

	# increment and skip first line
	let I=I+1; if [[ $I -eq 1 ]]; then continue; fi
		
	# make books
	$HTID2BOOKS $HTITEM_ID
	
done < $TSV

# fini
exit
