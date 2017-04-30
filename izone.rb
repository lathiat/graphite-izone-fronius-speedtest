require 'json'
require 'open-uri'

class Izone
  @ip = nil

  def initialize(ip)
    @ip = ip
  end

  def fetch(url)
    izone_data = open("http://#{@ip}/#{url}").read
    return JSON.parse(izone_data)
  end
end
