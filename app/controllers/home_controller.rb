class HomeController < ApplicationController
  require 'util'

  def index
    can?(:read, 'home') do
      @graphs = Rails.cache.fetch('graphs', :expires_in => 60.seconds) do
        require 'net/http'
        require 'thread'

        threads = []
        graphs = ActiveSupport::JSON.decode(ERB.new(File.read(Rails.root.join('config/graphs.json.erb'))).result)
        for group_name, group_graphs in graphs
          for graph_name, graph in group_graphs
            for slice in graph
              threads << Thread.new(slice) do |slice|
                http = create_api_conn()
                res = http.head("/devices/?query=#{CGI::escape ActiveSupport::JSON.encode(slice['query'])}")
                slice['data'] = res['Total'].to_i
                slice['href'] = url_for(controller: 'devices', action: 'index', params: {query: ActiveSupport::JSON.encode(slice['query'])}, only_path: true)
                slice.delete('query')
              end
            end
          end
        end
        threads.each(&:join)
        next graphs
      end
    end
  end
end
