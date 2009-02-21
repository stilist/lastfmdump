#!/usr/bin/ruby

# Dump last.fm listening data, using the v1 API.
#
# Usage:
# ./lastfmgrab.rb

$dumpDirectory = 'lastfm'
$username = 'stilist'

def getDateRange
 local = File.expand($dumpDirector)
 Dir.mkdir(local) unless File.directory?(local)

 range = "http://ws.audioscrobbler.com/1.0/user/#{username}/weeklychartlist.xml"

 
end

def dumpData(startDate, endDate)
end
