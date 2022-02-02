#!/usr/bin/env bash

# harvest-text.sh - given a key, secret, and HathiTrust identifier, build a plain text file; a front-end to harvest-text.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 11, 2019 - first cut; the result of refactoring
# July 14, 2019 - trapped for file not found
# July  4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff


# configure
HARVEST='./bin/harvest-text.pl'
TMP='./tmp'

# sanity check
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <HathiTrust identifier> <page>" >&2
	exit
fi

# more sanity checks
if [[ -z $HTKEY ]];    then echo "The environment variable named HTKEY is not defined. Call Eric."; exit; fi
if [[ -z $HTSECRET ]]; then echo "The environment variable named HTSECRET is not defined. Call Eric."; exit; fi

# get input
HTID=$1
PAGE=$2

# get content, capture result code, and rest
CONTENT=$( $HARVEST $HTID $PAGE )
SUCCESS=$?

# check for success; need to check for values greater than 1
if [[ $SUCCESS -eq 1 ]]; then

	# output content
	ITEM=$( printf "%04d" $PAGE )
	echo -e "\n$CONTENT\n" > "$TMP/page-$ITEM.txt"

fi

# trap for file not found
if [[ $SUCCESS -gt 1 ]]; then kill $PPID; fi

# done
exit
