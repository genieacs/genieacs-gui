
def create_api_conn
  http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
  http.use_ssl = Rails.configuration.genieacs_api_use_ssl
  #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  return http
end
