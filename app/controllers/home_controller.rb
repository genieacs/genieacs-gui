class HomeController < ApplicationController
  def index
    online_threshold_green = (Time.now - (60 * 10))
    online_threshold_yellow = (Time.now - (60 * 60 * 24))

    @online_green_query = {'summary.lastInform' => {'$gt' => online_threshold_green}}
    @online_yellow_query = {'summary.lastInform' => {'$gt' => online_threshold_yellow, '$lt' => online_threshold_green}}
    @online_red_query = {'summary.lastInform' => {'$lt' => online_threshold_yellow}}

    @online_green_count, @online_yellow_count, @online_red_count = Rails.cache.fetch('online_count', :expires_in => 60.seconds) do
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.get("/devices/?query=#{CGI::escape ActiveSupport::JSON.encode(@online_green_query)}")
      green = res['Total'].to_i
      res = http.get("/devices/?query=#{CGI::escape ActiveSupport::JSON.encode(@online_yellow_query)}")
      yellow = res['Total'].to_i
      res = http.get("/devices/?query=#{CGI::escape ActiveSupport::JSON.encode(@online_red_query)}")
      red = res['Total'].to_i
      [green, yellow, red]
    end
  end
end
