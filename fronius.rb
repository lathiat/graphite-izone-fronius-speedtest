require 'json'
require 'open-uri'

class Fronius
  @ip = nil

  def initialize(ip)
    @ip = ip
  end

  def fetch(url='/solar_api/v1/GetInverterRealtimeData.cgi?Scope=Device&DeviceID=1&DataCollection=CommonInverterData')
    data = open("http://#{@ip}/#{url}").read
    return JSON.parse(data)
  end
end
