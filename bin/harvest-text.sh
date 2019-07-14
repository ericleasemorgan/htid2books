#!/usr/bin/env bash

# harvest-text.sh - given a key, secret, and HathiTrust identifier, build a plain text file; a front-end to harvest-text.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 11, 2019 - first cut; the result of refactoring
# July 14, 2019 - trapped for file not found


# configure
HARVEST='./bin/harvest-text.pl'
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
CONTENT=$( $HARVEST $KEY $SECRET $HTID $PAGE )
SUCCESS=$?

# check for success; need to check for values greater than 1
if [[ $SUCCESS -eq 1 ]]; then

	# output content
	ITEM=$( printf "%04d" $PAGE )
	echo -e "\n$CONTENT\n" > "$PAGES/page-$ITEM.txt"

fi

# trap for file not found
if [[ $SUCCESS -gt 1 ]]; then kill $PPID; fi

# done
exit
