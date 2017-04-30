require 'json'
require 'open-uri'

class Speedtest
  @ip = nil

  def initialize(server=nil)
    @server = server
  end

  def fetch()
    result = %x[speedtest-cli --simple --server #{@server}]
    return result.split("\n").map {|t| t.match(/([[:alpha:]]+): ([0-9.]+) .*/)[1..2] }
  end
end
