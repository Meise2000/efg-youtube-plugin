package youtubeparser;

#-----------------------------------------------------------------------------------------------
# Global elements ... 
#-----------------------------------------------------------------------------------------------
my ($current, $element);
my $all;

#-----------------------------------------------------------------------------------------------
# Parses the given XML file and returns an object (array of hashes) containing the videos
#-----------------------------------------------------------------------------------------------
sub parse {
    my ($filename) = @_;

    $all = [];
    $current = undef;
    $element = undef;
    my $parser = new XML::Parser(
        Style => 'Stream', 
        Handlers => { Start  => \&_handleStartTag,
                  End    => \&_handleEndTag,
                  Char   => \&_handleText });
        $parser->parsefile($filename, ProtocolEncoding => 'UTF-8');
    my @res = _convert($all);
    return \@res;
}

#-----------------------------------------------------------------------------------------------
# Called on every start tag
#-----------------------------------------------------------------------------------------------
sub _handleStartTag {
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

#-----------------------------------------------------------------------------------------------
# Called on every end tag
#-----------------------------------------------------------------------------------------------
sub _handleEndTag {
    my ($parser, $tag) = @_;
    $element = undef;
}

#-----------------------------------------------------------------------------------------------
# Called on every text node
#-----------------------------------------------------------------------------------------------
sub _handleText {
    my ($parser, $text) = @_;
    if ($element) {
        if ($current->{$element}) {
            $current->{$element} .= $text;
        } else {
            $current->{$element} = $text;
        }
    }
}

#-----------------------------------------------------------------------------------------------
# Extract data from pattern
#-----------------------------------------------------------------------------------------------
sub _convert {
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
        $item->{'streamed'} = _findStreamingDate($_->{'published'});
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

#-----------------------------------------------------------------------------------------------
# Stream is always published on sunday - no matter when created on youtube
#-----------------------------------------------------------------------------------------------
sub _findStreamingDate {
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

1;