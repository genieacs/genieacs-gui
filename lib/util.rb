
def create_api_conn(&block)
  host = Rails.configuration.genieacs_api_host
  port = Rails.configuration.genieacs_api_port
  use_ssl = Rails.configuration.genieacs_api_use_ssl

  if block_given?
    Net::HTTP.start(host, port, {use_ssl: use_ssl}, &Proc.new)
  else
    http = Net::HTTP.new(host, port)
    http.use_ssl = use_ssl
    return http
  end
end

def query_resource(http, resource, query, projection = nil, skip = nil, limit = nil, sort = nil)
  args = {}
  args['query'] = ActiveSupport::JSON.encode(query) if query
  args['projection'] = projection.join(',') if projection
  args['skip'] = skip if skip
  args['limit'] = limit if limit
  args['sort'] = ActiveSupport::JSON.encode(sort) if sort


  host = Rails.configuration.genieacs_api_host
  port = Rails.configuration.genieacs_api_port
  use_ssl = Rails.configuration.genieacs_api_use_ssl

  request = Net::HTTP::Get.new("/#{resource}?#{args.to_query}")
  http.request request do |res|
    total = res['Total'].to_i
    timestamp = res['Date'].to_time
    if not block_given?
      ret = {timestamp: timestamp, total: total, result: []}
    end
    counter = 0
    line = ''
    res.read_body() do |chunk|
      chunk.each_line() do |l|
        line += l
        next if not line.end_with?($/)

        if line.end_with?(",#{$/}")
          obj = JSON.parse(line[0...0-",#{$/}".length])
          if ret
            ret[:result] << obj
          else
            yield(obj, counter, total, timestamp)
          end
          counter += 1
          line = ''
        elsif line != $/ and line != "[#{$/}" and line != "]#{$/}"
          obj = JSON.parse(line[0...0-"#{$/}".length])
          if ret
            ret[:result] << obj
          else
            yield(obj, counter, total, timestamp)
          end
          counter += 1
        end
        line = ''
      end
    end
    if ret
      return ret
    else
      yield(nil, 0, total, timestamp) if counter == 0
    end
  end
end
