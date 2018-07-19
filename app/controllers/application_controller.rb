require 'net/http'
require 'json'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

def baseUrl
  @httpIp = 'http://192.168.21.135'
  # @httpIp = 'http://10.82.137.193'
end



end
