#!/usr/bin/env bash

# htid2txt.sh - given a key, secret, HathiTrust identifier, and size, build a plain text file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation
# July     11, 2019 - figured out how to parallelize the process; substantial speed increase
# July     14, 2019 - removed need for size parameter; exported size for htid2pdf.sh
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff
# August    1, 2020 - added iconv to output is always utf-8


# configure
HARVEST='./bin/harvest-text.sh'
TXT='./txt'
TMP='./tmp'
MAXIMUM=10000
JOBS='5'

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

# make sane
mkdir -p $TMP
mkdir -p $TXT
rm   -rf $TMP/*.txt

# initialize outputs name
OUTPUT=$( echo $HTID | sed "s/\//-/g" )

# don't to the work if it is already done
if [[ -f "$TXT/$OUTPUT.txt" ]]; then exit 0; fi

# harvest each page
seq 1 $MAXIMUM | parallel --jobs $JOBS $HARVEST $HTID

# build the book and output
BOOK=$( cat $TMP/*.txt )
echo -e "$BOOK" | iconv -t UTF-8//IGNORE > "$TXT/$OUTPUT.txt"

# compute the number of pages in the document
LENGTH=$( ls -1q ./tmp/*.txt | wc -l |  tr -d ' ' )
echo "Number of pages: $LENGTH" >&2
echo $LENGTH
exit
