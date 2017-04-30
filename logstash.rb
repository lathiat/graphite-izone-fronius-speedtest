#!/usr/bin/ruby
require 'uri'
require 'open-uri'
require 'json'
require 'logstash-logger'

BASE_URI = "http://10.48.134.21"

system_input = open("#{BASE_URI}/SystemSettings").read
zone_input = JSON.parse(open("#{BASE_URI}/Zones1_4").read)

file_logger = LogStashLogger.new(type: :unix, path: '/tmp/logstash.sock')

file_logger.tagged(:system) do
  file_logger.info system_input
end
file_logger.tagged(:zone) do 
  zone_input.each do |z|
    file_logger.info z
  end
end
