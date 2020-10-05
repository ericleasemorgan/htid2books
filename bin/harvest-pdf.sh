#!/usr/bin/env bash

# harvest-pdf.sh - given a key, secret, and HathiTrust identifier, build a plain text file; a front-end to harvest-pdf.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 11, 2019 - first cut; the result of refactoring
# July 14, 2019 - a certain type of creativity

# configure
HARVEST='./bin/harvest-pdf.pl'
PAGES='./pages'

# sanity check
if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
	echo "Usage: $0 <key> <secret> <HathiTrust identifier> <page>" >&2
	exit
fi

# get input
KEY=$1
SECRET=$2
HTID=$3
PAGE=$4

# get content, capture result code, and rest
ITEM=$( printf "%04d" $PAGE )
$HARVEST $KEY $SECRET "$HTID" $PAGE > "$PAGES/page-$ITEM.png"

