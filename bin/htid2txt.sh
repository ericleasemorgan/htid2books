#!/usr/bin/env bash

# htid2txt.sh - given a key, secret, HathiTrust identifier, and size, build a plain text file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation
# July     11, 2019 - figured out how to parallelize the process; substantial speed increase
# July     14, 2019 - removed need for size parameter; exported size for htid2pdf.sh


# configure
HARVEST='./bin/harvest-text.sh'
PAGES='./pages'
BOOKS='./books'
TMP='./tmp'
MAXIMUM=1000

# sanity check
if [[ -z $1 || -z $2 || -z $3 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
HTID=$3
SIZE=$4

# make sane
mkdir -p $PAGES
mkdir -p $BOOKS
rm   -rf $PAGES/*.txt
rm   -rf $TMP/$HTID.txt

# harvest each page
seq 1 $MAXIMUM | parallel $HARVEST $KEY $SECRET $HTID {}

# build the book and output
BOOK=$( cat $PAGES/*.txt )
echo -e "$BOOK" > $BOOKS/$HTID.txt

# compute the number of pages in the document
LENGTH=$( cat tmp/$HTID.txt | sort | head -n 1 )
let LENGTH=LENGTH-1

# done; export size
exit $LENGTH


