use Test::More tests => 1;

use lib '.'; 
require 'youtubeparser.pm';

# one entry 
my $videos = youtubeparser::parse('test_video1.xml'); 
is(scalar(@$videos), 1, "only one video is returned");
