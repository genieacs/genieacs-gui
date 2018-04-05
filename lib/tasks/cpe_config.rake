# frozen_string_literal: true

namespace :cpe_config do
  desc 'Load CPE config from api then save'
  task save: :environment do
    require 'util'
    require 'net/http'

    puts 'Start loading CPE config ...'

    projection = ['_id']
    http = create_api_conn
    resp = query_resource(http, 'devices', {}, projection)
    devices_resp = resp[:result]

    puts "Found #{resp[:total]} devices"
    puts 'Start copy CPE config ...'

    devices_resp.map do |data|
      resp = query_resource(http, 'devices', _id: data['_id'])
      result = resp[:result][0]
      info = result['_deviceId']
      last_inform = result['_lastInform']
      parameters = result['InternetGatewayDevice']

      device = Device.find_or_create_by(device_id: data['_id'])
      device.update(info: info, last_inform: last_inform)
      device.parameters << Parameter.new(parameters: parameters)
    end

    puts 'Finished'
  end
end
