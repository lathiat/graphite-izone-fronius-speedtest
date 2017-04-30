#!/usr/bin/ruby
require 'graphite-api'
require 'graphite-api/core_ext/numeric'
require_relative 'speedtest'
require_relative 'fast'
require 'pp'
# BOM Jandakot http://www.bom.gov.au/fwo/IDW60901/IDW60901.94609.json

client = GraphiteAPI.new(graphite: 'localhost:2003')
speedtest = Speedtest.new("2627")
fast = Fast.new()

def print_metrique(output_str)
  if ARGV[0] == "1"
    puts output_str
  end
end

begin
  speedtest_input = speedtest.fetch
  speedtest_input.each do |k, v|
    metric = ['speedtest', k.downcase].join('.')
    print_metrique client.metrics(metric => v)
  end
rescue
end
begin
  fast_input = fast.fetch
  print_metrique client.metrics(['speedtest', 'download-fast'].join('.') => fast_input)
rescue
end


