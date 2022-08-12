#!/usr/bin/env bash

# htid2books.sh - given a key, secret, and HathiTrust identifier, output plain text and PDF files of books

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first cut
# July     14, 2019 - added size; broke collection builder
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff


# configure
HTID2TXT='./bin/htid2txt.sh'
HTID2PDF='./bin/htid2pdf.sh'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <HathiTrust identifier>" >&2
	exit
fi

# more sanity checks
if [[ -z $HTKEY ]];    then echo "Error: The environment variable named HTKEY is not defined. Call Eric."; exit; fi
if [[ -z $HTSECRET ]]; then echo "Error: The environment variable named HTSECRET is not defined. Call Eric."; exit; fi

# get input
HTID=$1

# do the work and done; tricky
LENGTH=$( $HTID2TXT $HTID )
echo "length: $LENGTH" >&2

$HTID2PDF $HTID $LENGTH
exit
