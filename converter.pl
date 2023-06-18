use strict;

use XML::Parser;
use DateTime;
use utf8;

my $all = [];
my ($current, $element);
my $parser = new XML::Parser(
    Style => 'Stream', 
    Handlers => { Start  => \&handleStartTag,
                  End    => \&handleEndTag,
                  Char   => \&handleText });
$parser->parsefile('videos.xml', ProtocolEncoding => 'UTF-8');

my @res = convert($all);

writeJson(\@res);

sub toJson {
    my ($obj) = @_;

    if (ref $obj eq 'Hash') {
        return objectToJson($obj);
    } elsif (ref $obj eq 'Array') {
        return arrayToJson($obj);
    } elsif ($obj =~ m/[\-?\d\.]+$/) {
        return $obj;
    } elsif ($obj eq 'false' || $obj eq 'true') {
        return $obj;
    } elsif (!$obj) {
        return 'null';
    }
    $obj =~ s/&/&quot;/g;
    return '"' . $obj . '"';
}

sub arrayToJson {
    my ($obj) = @_;

    my @mapped = map toJson($_), @$obj;
    return '[' . join(',', @mapped) . ']';
}

sub objectToJson {
    my ($obj) = @_;

    my $value = join(',', map {'"' . $_ . '":' . toJson($obj->{$_}) } (keys %$obj));
    return '{' . $value . '}';
}

sub writeJson {
    my ($data) = @_;

    my $json = toJson($data);
    open (FILE, ">all.json") || die "$!";
    binmode(FILE, ":utf8");
    print FILE $json;
    close(FILE);
}

sub convert {
    my ($parsed) = @_;

    my $res = [];
    foreach (@$parsed) {
        my($title, $speaker, $source) = split(' \| ', $_->{'title'});
        my $item = {};
        $item->{'speaker'} = $speaker;
        $item->{'de'} = { 'title' => $title };
        if ($source =~ m/(.+) \((.+)\)$/) {
            $item->{'de'}->{'source'} = $1;
            $item->{'type'} = $2;
        } else {
            $item->{'de'}->{'source'} = $source;
        }
        $item->{'streamed'} = findStreamingDate($_->{'published'});
        if ($_->{'media:description'} =~ m/^🇩🇪\n([^🇮🇷]+)(🇮🇷\n(.+))?/g) {
            my $description = $1;
            my $descriptionIr = $2;
            $description =~ s/\n//g;
            $item->{'de'}->{'desc'} = $description;

            $descriptionIr =~ s/\n//g;
            $item->{'ir'} = { 'desc' => $descriptionIr };
        } 
        push(@$res, $item);
    }
    return sort {$b->{'streamed'} <=> $a->{'streamed'}} @$res;
}

sub findStreamingDate {
    my ($publishedDate) = @_;
    my $res = undef;
    if ($publishedDate =~ m/^(\d{4})\-(\d{2})\-(\d{2})T.+$/g) {
        my $date = DateTime->new(year => $1, month => $2, day => $3, hour => 10, minute => 45); 
        my $desired_dow = 0; # Sunday 
        if ($date->day_of_week != $desired_dow) {
            $date->add(days => ($desired_dow - $date->day_of_week) % 7); 
        }
        $res = $date;
    }
    return $res;
}

sub handleStartTag {
    my ($parser, $tag) = @_;
    if ($tag eq 'entry') {
        $current = {};
        push(@$all, $current);
    } elsif ($tag eq 'id' || $tag eq 'title' || $tag eq 'published' || $tag eq 'media:description') {
        $element = $tag;
    } else {
        $element = undef;
    }
}

sub handleEndTag {
    my ($parser, $tag) = @_;
    $element = undef;
}

sub handleText {
    my ($parser, $text) = @_;
    if ($element) {
        if ($current->{$element}) {
            $current->{$element} .= $text;
        } else {
            $current->{$element} = $text;
        }
    }
}
