use strict;

use XML::Parser;
use DateTime;
use utf8;
use lib '.'; 

require "jsonconverter.pm";
require "youtubeparser.pm";

my $source = $ARGV[0]; 
my $target = $ARGV[1];

my $videos = youtubeparser::parse($source);
my $json = jsonconverter::toJson($videos);

open (FILE, ">$target") || die "$!";
binmode(FILE, ":utf8");
print FILE $json;
close(FILE);

