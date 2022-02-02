#!/usr/bin/env bash

# harvest-pdf.sh - given a key, secret, and HathiTrust identifier, build a plain text file; a front-end to harvest-pdf.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July     11, 2019 - first cut; the result of refactoring
# July     14, 2019 - a certain type of creativity
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff
# November 26, 2020 - changed output to jpg, and this was a surprise; on Thanksgiving in Lancaster during a pandemic


# configure
HARVEST='./bin/harvest-pdf.pl'
TMP='./tmp'

# sanity check
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <HathiTrust identifier> <page>" >&2
	exit
fi

# more sanity checks
if [[ -z $HTKEY ]];    then echo "Error: The environment variable named HTKEY is not defined. Call Eric."; exit; fi
if [[ -z $HTSECRET ]]; then echo "Error: The environment variable named HTSECRET is not defined. Call Eric."; exit; fi

# get input
HTID=$1
PAGE=$2

# get content, capture result code, and rest
ITEM=$( printf "%04d" $PAGE )
$HARVEST $HTID $PAGE > "$TMP/page-$ITEM.jpg"

