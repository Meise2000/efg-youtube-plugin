use Test::More tests => 29;

use utf8;
use lib '.'; 
require '../src/youtubeparser.pm';
require '../src/jsonconverter.pm';

# one entry 
my $videos = youtubeparser::parse('test_video1.xml'); 
is(scalar(@$videos), 1, "only one video is returned");
my $testee = $$videos[0]; 
is($testee->{'id'}, 'MY-ID', "ID should be parsed correctly");
is($testee->{'speaker'}, 'Stephan H.', "speaker should be parsed correctly");
is($testee->{'streamed'}, '2023-04-02T10:45:00', "starts always at 10:45 on a sunday");
is($testee->{'de'}->{'desc'}, 'Pommes', "German description should be parsed correctly");
is($testee->{'de'}->{'title'}, 'Gegenstand der Passion', "German title should be parsed correctly");
is($testee->{'de'}->{'source'}, 'Johannes 19', "German source should be parsed correctly");
is($testee->{'ir'}->{'desc'}, 'موضوع اشتیاق', "Farsi description should be parsed correctly");
is($testee->{'ir'}->{'title'}, ' سیب زمینی سرخ کرده', "Farsi title should be parsed correctly");
is($testee->{'ir'}->{'source'}, 'یوحنا 19', "Farsi source should be parsed correctly");

# two entries
$videos = youtubeparser::parse('test_video2.xml'); 
is(scalar(@$videos), 2, "two videos are returned");
$testee = $$videos[1]; 
is($testee->{'id'}, 'MY-ID', "ID should be parsed correctly");
is($testee->{'speaker'}, 'Stephan H.', "speaker should be parsed correctly");
is($testee->{'streamed'}, '2023-04-02T10:45:00', "starts always at 10:45 on a sunday");
is($testee->{'de'}->{'desc'}, 'Pommes', "German description should be parsed correctly");
is($testee->{'de'}->{'title'}, 'Gegenstand der Passion', "German title should be parsed correctly");
is($testee->{'de'}->{'source'}, 'Johannes 19', "German source should be parsed correctly");
is($testee->{'ir'}->{'desc'}, 'موضوع اشتیاق', "Farsi description should be parsed correctly");
is($testee->{'ir'}->{'title'}, ' سیب زمینی سرخ کرده', "Farsi title should be parsed correctly");
is($testee->{'ir'}->{'source'}, 'یوحنا 19', "Farsi source should be parsed correctly");
$testee = $$videos[0]; 
is($testee->{'id'}, 'MY-ID2', "ID should be parsed correctly");
is($testee->{'speaker'}, 'Hugo Boss', "speaker should be parsed correctly");
is($testee->{'streamed'}, '2023-04-09T10:45:00', "starts always at 10:45 on a sunday");
is($testee->{'de'}->{'desc'}, 'Pommes2', "German description should be parsed correctly");
is($testee->{'de'}->{'title'}, 'Was anderes', "German title should be parsed correctly");
is($testee->{'de'}->{'source'}, 'Markus 2', "German source should be parsed correctly");
is($testee->{'ir'}->{'desc'}, 'موضوع اشتیاق', "Farsi description should be parsed correctly");
is($testee->{'ir'}->{'title'}, ' سیب زمینی سرخ کرده', "Farsi title should be parsed correctly");
is($testee->{'ir'}->{'source'}, 'یوحنا 19', "Farsi source should be parsed correctly");

#binmode(STDERR, ":utf8");
#print STDERR jsonconverter::toJson($videos);