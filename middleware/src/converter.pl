use strict;

use XML::Parser;
use DateTime;
use utf8;
use lib '.'; 

require "jsonconverter.pm";
require "youtubeparser.pm";

my $videos = youtubeparser::parse('../test/videos.xml');
my $json = jsonconverter::toJson($videos);

open (FILE, ">all.json") || die "$!";
binmode(FILE, ":utf8");
print FILE $json;
close(FILE);

