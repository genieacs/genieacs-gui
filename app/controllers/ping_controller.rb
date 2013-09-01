class PingController < ApplicationController
  def index
    require 'net/http'
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, 7557)
    res = http.send_request(request.method, "/ping/#{params[:ip]}", nil)

    self.response.status = res.code
    res.each_header { |key,value|
      self.response.headers[key] = value
    }
    self.response.headers.delete('transfer-encoding')
    self.response.headers['Content-Type'] = res['Content-Type']

    self.response_body = res.body
  end

end
