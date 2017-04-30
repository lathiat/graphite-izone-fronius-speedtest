#!/usr/bin/ruby
require 'graphite-api'
require 'graphite-api/core_ext/numeric'
require_relative 'izone'
require_relative 'fronius'
require 'pp'
# BOM Jandakot http://www.bom.gov.au/fwo/IDW60901/IDW60901.94609.json

client = GraphiteAPI.new(graphite: 'localhost:2003')
izone = Izone.new("10.48.134.14")
fronius = Fronius.new("10.48.134.21")

def print_metrique(output_str)
  if ARGV[0] == "1"
    puts output_str
  end
end

begin
	system_input = izone.fetch("SystemSettings")
rescue
end
begin
	solar_input = fronius.fetch
rescue
end

system_input.each do |k, v|
  case v
  when "on", "true"
    v = 1
  when "off", "false"
    v = 0
  end

  case k
  when "SysMode", "SysFan"
    k, v = "#{k}.#{v}", 1
  end
  metric = ['izone', 'system', k].join('.')
  print_metrique client.metrics(metric => v)
end
begin
  ["Zones1_4", "Zones5_8", "Zones9_12"].each do |ep|
    zone_input = izone.fetch(ep)
    zone_input.each do |z|
      z.each do |k, v|
        case v
        when "on", "true"
          v = 1
        when "off", "false"
          v = 0
        end
        case k
        when "Type", "Mode"
          k, v = "#{k}.#{v}", 1
        end
        metric = ['izone', 'zone', 'byIndex', z['Index'], k].join('.')
        print_metrique client.metrics(metric => v)
    
        metric = ['izone', 'zone', 'byName', z['Name'].gsub(/ /, '_'), k].join('.')
        print_metrique client.metrics(metric => v)
      end
    end
  end
rescue
end

if solar_input
  solar_input["Body"]["Data"].each do |k, v|
    if k == "DeviceStatus"
      v.each {|stat, val| print_metrique client.metrics("fronius.status.#{stat}" => val) if val.respond_to?(:to_f) }
    elsif v["Value"]
      print_metrique client.metrics("fronius.#{k}" => v["Value"])
    end
  end
end
