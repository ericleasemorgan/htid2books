#!/usr/bin/env bash

# htid2txt.sh - given a key, secret, HathiTrust identifier, and size, build a plain text file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation
# July     11, 2019 - figured out how to parallelize the process; substantial speed increase


# configure
HARVEST='./bin/harvest-text.sh'
PAGES='./pages'
BOOKS='./books'

# sanity check
if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier> <size>" >&2
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
rm -rf $PAGES/*.txt

# harvest each page
seq 1 $SIZE | parallel $HARVEST $KEY $SECRET $HTID {}

# build the book and output
BOOK=$( cat $PAGES/*.txt )
echo -e "$BOOK" > $BOOKS/$HTID.txt

# done
exit 
