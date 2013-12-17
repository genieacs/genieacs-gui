class HomeController < ApplicationController
  def index
    @graphs = Rails.cache.fetch('graphs', :expires_in => 60.seconds) do
      require 'net/http'
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)

      graphs = ActiveSupport::JSON.decode(ERB.new(File.read('config/graphs.json.erb')).result)
      for group_name, group_graphs in graphs
        for graph_name, graph in group_graphs
          for slice in graph
            res = http.head("/devices/?query=#{CGI::escape ActiveSupport::JSON.encode(slice['query'])}")
            slice['data'] = res['Total'].to_i
            slice['href'] = url_for(controller: 'devices', action: 'index', params: {query: ActiveSupport::JSON.encode(slice['query'])})
            slice.delete('query')
          end
        end
      end
      next graphs
    end
  end
end
