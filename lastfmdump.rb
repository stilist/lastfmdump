#!/usr/bin/ruby

# Dump last.fm listening data, using the v1 API.
#
# Usage:
# ./lastfmgrab.rb
#
# Thanks to http://www.warp7design.com/tutorials.php?id=3 for the v1 reference.
#
# Code is provided under the MIT license. See LICENSE for details.

require 'net/http'
require 'rexml/document'

# Settings

$dumpDirectory = 'lastfm'
$user = 'stilist'
$lastfm = Net::HTTP.new('ws.audioscrobbler.com')

def getDates
  $local = File.expand_path($dumpDirectory)
  Dir.mkdir($local) unless File.directory?($local)

  dates = $lastfm.start { |http|
    req = Net::HTTP::Get.new("/1.0/user/#{$user}/weeklychartlist.xml")
    http.request(req).body
  }

  index = File.new('weeks.xml', 'w')
  index.puts dates
  index.close

  REXML::Document.new(dates).elements.each('weeklychartlist/chart') do |week|
    startDate = week.attributes['from']
    endDate = week.attributes['to']

    dumpData(startDate, endDate)

    # Three-second pause to reduce server strain
    sleep 3
  end
end

def dumpData(startDate, endDate)
  puts "Processing #{startDate} to #{endDate}"

  week = File.new("#{$local}/#{startDate}.xml", 'w')

  tracks = $lastfm.start { |http|
    req = Net::HTTP::Get.new("/1.0/user/#{$user}/weeklytrackchart.xml?from=#{startDate}&to=#{endDate}")
    http.request(req).body
  }

  week.puts tracks
  week.close
end

getDates
