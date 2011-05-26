#! /usr/bin/ruby

require 'rubygems'
require 'httparty'

class Lineup
  include HTTParty
  format :xml
end

data = Lineup.get('http://192.168.1.32/US-20169-lineup.xml')

data['LineupUIResponse']['Lineup'].each do |lineup|
    name = lineup['DisplayName']
    printf "%s\n\n", name

    lineup['Program'].each do |program|
        printf "%3s %s %-9s %-4s %-6s %-12s %s\n", program['PhysicalChannel'], program['Modulation'], program['Frequency'], program['ProgramNumber'], program['GuideNumber'], program['GuideName'], program['Resolution']
    end

    puts ""
end

# data['LineupUIResponse']['Lineup'][0]['Program'][0].keys
# ["Modulation", "Frequency", "PhysicalChannel", "ProgramNumber", "GuideNumber", "GuideName", "Resolution", "Aspect", "Snapshot"]
