require 'json'
require 'open-uri'

class Fast
  @ip = nil

  def initialize(server=nil)
    @server = server
  end

  def fetch()
    result = %x[fast]
    return result.match(/([0-9.]+) Mbps/)[1]
  end
end
