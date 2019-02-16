# htid2books

Given an access key, secret token, and a HathiTrust identifier, output plain text as well as PDF versions of a book.


## Synopsis

   1. `./bin/htid2txt.sh <token> <key> <identifier>`
   2. `./bin/htid2pdf.sh <token> <key> <identifier> <length>`
   3. `./bin/htid2books.sh <token> <key> <identifier>`
   4. `./bin/collection2books.sh <token> <key> <tsv>`


## Introduction

The [HathiTrust](https://www.hathitrust.org) is a really cool, and in my humble opinion, under-utilized information resource. Nowhere else can one have so much free &amp; full text access to such a large collection of books, except maybe from the [Internet Archive](https://archive.org). If I remember correctly, the 'Trust was created in response to the venerable [Google Books Project](https://www.google.com/googlebooks/library/). Google digitized huge swaths of partner libraries's collections, and the results were amalgamated into a repository, primarily for the purposes of preservation. "An elephant never forgets." [1]

As the 'Trust matured, so did its services. It created a [full text catalog](https://babel.hathitrust.org/cgi/ls?a=page&page=advanced) of holdings. It enabled students &amp; scholars the ability to create personal collections. It offered libraries the opportunity to deposit digitized materials into the centralized repository. It created the [HathiTrust Research Center](https://analytics.hathitrust.org) which "enables computational analysis" of works in the collection. And along the way it implemented a few application programmer interfaces (APIs). Given one of any number of identifiers, the [Bibliographic API](https://www.hathitrust.org/bib_api) empowers a person to download metadata describing items in the collection. Given authentication credentials and one of any number of identifiers, the [Data API](https://www.hathitrust.org/data_api) empowers a person to download items of interest; the Data API enables a person to download HathiTrust items in plain (optical character recognition, OCR) text as well as image formats.

This system -- htid2books -- is intended to make it easy to download HathiTrust items. It will output plain text files suitable for text mining as well as PDF files for printing &amp; traditional reading.


## Requirements

To use htid2books you will first need to acquire authentication credentials. These include an access token and "secret key" freely available from the 'Trust to just about any one and upon [request](https://babel.hathitrust.org/cgi/kgs/request).

You will then need to download the code itself.

The code requires quite a bit of infrastructure. First of all, it is implemented as a set of six Bash and Perl scripts. People using Linux and Macintosh computers will have no problem here, but folks using Windows will need to install Bash and Perl. ("Sorry, really!") Second, in order to authenticate, a Perl library called [OAuth::Lite](https://metacpan.org/release/OAuth-Lite) is needed. This is most easily installed with some variation of the `cpan install OAuth::Lite` command. Lastly, in order to build a PDF file from sets of downloaded images, you will need a suite of software called [ImageMagick](https://www.imagemagick.org). Installing ImageMagick is best done with some sort of package manager. People using Linux will run a variation of the `yum install imagemagick` or `apt-get install imagemagick` commands. People using Macintoshes might "brew" the installation -- `brew install imagemagick`.


## Usage


### `./bin/htid2txt.sh`

To download a plain text version of a HathiTrust item, you first change directories to the system's root and run `./bin/htid2txt.sh`. The script requires three inputs:

   1. `token` - your access token
   2. `key` - your secret key
   3. `identifier` - a HathiTrust... identifier

For example, `./bin/htid2txt.sh 194dfe2bg3 xa5350f0c44548487778e942518a nyp.33433082524681` In this case, the script will do the tiniest bit of validation, repeatedly run a Perl script (`htid2txt.pl`) to get the OCR of an individual page, cache the result, and when there no more pages in the given book, concatenate the cache into a text file saved in the directory named `./books`.


### `./bin/htid2pdf.sh`

Similarly, to create a PDF version of a given HathiTrust item run `./bin/htid2pdf.sh`. It requires four inputs:

   1. `token` - your access token
   2. `key` - your secret key
   3. `identifier` - a HathiTrust... identifier
   4. `length` - the number of page images to download

Like above, `htid2pdf.sh` will repeatedly run `htid2pdf.pl`, cache image files, and when done concatenate them into a PDF file saved in the `./books` directory. For example, `./bin/htid2pdf.sh 194dfe2bg3 xa5350f0c44548487778e942518a nyp.33433082524681 28`


### `./bin/htid2books.sh` 

Finally, `./bin/htid2books.sh` is one script to rule them all. Given a token, secret, and identifier, `htid2books.sh` will sequentially run `htid2txt.sh` and `htid2pdf.sh`.


### Sample identifiers

Some interesting HathiTrust identifiers include:

   * [hvd.32044018865758](https://hdl.handle.net/2027/hvd.32044018865758) - <em>Henry D. Thoreau : Emerson's obituary</em> by Ralph Waldo Emerson (1904)
   * [mdp.39015024076484](https://hdl.handle.net/2027/mdp.39015024076484) - <em>More nonsense, pictures, rhymes, botany, etc.</em> by Edward Lear (1872)
   * [nyp.33433075812416](https://hdl.handle.net/2027/nyp.33433075812416) - <em>The pearl of the Andes; a tale of love and adventure</em> by Gustave Aimard ([186-?])
   * [nyp.33433082524681](https://hdl.handle.net/2027/nyp.33433082524681) - <em>Three little kittens</em> by R. M. Ballantyne (1859)
   * [uc1.b3322717](https://hdl.handle.net/2027/uc1.b3322717) - <em>The blessed damozel</em> by Dante Gabriel Rossetti (1898)


## Advanced usage

Given a delimited text file, such as HathiTrust collection file, it is more than possible to loop through the file, feed HathiTrust identifiers to `htid2books.sh` and ultimately create a "library". A script named `collection2books.sh` is included just for this process. Usage:

   * `./bin/collection2books.sh <token> <key> <tsv>`
   
And a collection file named `./etc/collection.tsv` can be used as sample input - [four works by Charlotte Bronte](https://babel.hathitrust.org/cgi/mb?a=listis;c=954927440). 


## Discussion

Again, the HathiTrust is a wonderful resource. As a person who is employed to provide text mining services to students, faculty, and staff of a university, the HathiTrust's collections are a boon to scholarship.

The HathiTrust is a rich resource, but it is not easy to use at the medium scale. Reading &amp; analyzing a few documents is easy. It is entirely possible to manually generate PDF files, download them, print them (gasp!), extract their underlying plain (OCR) text, and use both traditional as well as non-traditional methods (text mining) to read their content. At the other end of the scale I might be able to count & tabulate all of the adjectives used in the 19th Century or see when the word "ice cream" first appeared in the lexicon.

On the other hand, I believe more realistic use cases exist: analyzing the complete works of Author X, comparing &amp; contrasting Author X with Author Y, learning how the expression or perception of gender may have changed over time, determining whether or not there are themes associated with specific places, etc. I imagine the following workflow:

   1. create HathiTrust collection
   2. download collection as TSV file
   3. use something like Excel, a database program, or OpenRefine to create subsets of the collection
   4. programmatically download items' content & metadata
   5. update TSV file with downloaded &amp; gleaned information
   6. do analysis against the result
   7. share results &amp; analysis

Creating the collection (#1) is easy. Search the 'Trust, mark items of interest, repeat until done (or tired). 

Downloading (#2) is trivial. Mash the button.

Creating subsets (#3) is easier than one might expect. Yes, there are <em>many</em> duplicates in a collection, but [OpenRefine](http://openrefine.org) is <em>great</em> at normalizing ("clustering") data, and once it is normalized, duplicates can be removed confidently. In the end, a "refined" set of HathiTrust identifiers can be output. 

Given a set of identifiers &amp; APIs, it ought to be easy to programmatically download (#4) the many flavors of 'Trust items: PDF, OCR plain text, bibliographic metadata, and the cool JSON files with embedded part-of-speech analysis. This is the part which is giving me the most difficulty. Slow; download speeds of 1000 bytes/minute. Access control &amp; authentication, which I sincerely understand & appreciate. Multiple data structures. For example, the bibliographic metadata is presented as a stream of JSON, and embedded in it is an escaped XML file, which, in turn, is the manifestation of a MARC bibliographic record. Yikes!

After the many flavors of content are downloaded, more interesting information can be gleaned: sentences, parts-of-speech, named entities, readability scores, sentiment measures, log-likelihood ratios, "topics" & other types of clusters, definitive characteristics of similarly classified documents, etc. In the end the researcher would have created a rich & thorough dataset (#5). 

Through traditional reading as well as through statistics, the researcher can then do #6 against the data set(s) and PDF files.

Again, the HathiTrust is really cool, but getting content out of it is not easy. But maybe I'm trying to use it when my use case is secondary to the 'Trust's primary purpose. After all, maybe the 'Trust is primarily about preservation. "An elephant never forgets."


## Caveats

There are a number of limitations to this system. 

First of all, not all HathiTrust items are available for downloading. In general, anything dated before 1923 is fair game, but even then Google "owns" some of the items and they are not accessible.

Second, HathiTrust identifiers often contain reserved characters used by computer file systems. Most notably the slash (/) and period (.) characters. By default, this system saves files using the HathiTrust identifiers. The use of reserved characters may confuse your file system.

Third, the collection files from the HathiTrust and the collection files from the HathiTrust Research Center manifest different data structures. The files from the 'Trust are tab-delimited (TSV) files, and `collection2books.sh` is designed to use them as input. On the other hand, the collection files from the Center are comma-separated value (CSV) files. Moreover, the number of fields in the respective collection files are different. I suppose `collection2books.sh` could be hacked so either type of input were acceptable, but all me lazy. On the other hand `collection2books.sh` is really intended to be a template for reading any number of delimited files and subsequent processing. [2]

Fourth and most significantly, the system is not fast. This is not because htid2books is doing a lot work. It is not. It is not because the network is slow. It is not because of the volume of data being transfered. Instead, it is because content is distributed one page at a time; there does not seem to be any sort of bulk downloading option. Still, there are a couple of possible solutions. For example, maybe authentication needs to happen only once? If so, then the system could be refactored. Alternatively, multi-threading and/or parallel processing could be employed. Download a single page for each processor on a computer. Such improvements are left an an exercise to the reader.


## Notes

[1] For more detail about the Google Books Project, see the [Wikipedia article](https://en.wikipedia.org/wiki/Google_Books).

[2] Software is never done. If it were, then it would be called "hardware".

---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;   
February 16, 2019
