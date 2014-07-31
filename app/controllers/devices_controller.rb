class DevicesController < ApplicationController
  require 'net/http'
  require 'json'

  def flatten_params(params, prefix = '')
    output = []
    for n, v in params
      next if n.start_with?('_') or v.is_a?(String)
      v['_path'] = "#{prefix}#{n}"
      output << v

      if not v.include?('_value')
        output += flatten_params(v, prefix ? "#{prefix}#{n}." : "#{n}.")
      end
    end
    return output
  end

  def get_device(id)
    query = {
      'query' => ActiveSupport::JSON.encode({'_id' => id}),
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/devices/?#{query.to_query}")
    @now = res['Date'].to_time
    return ActiveSupport::JSON.decode(res.body)[0]
  end

  def get_device_tasks(device_id)
    query = {
      'query' => ActiveSupport::JSON.encode({'device' => device_id}),
      'sort' => ActiveSupport::JSON.encode({'timestamp' => 1})
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/tasks/?#{query.to_query}")
    return ActiveSupport::JSON.decode(res.body)
  end

  def find_devices(query, skip = 0, limit = Rails.configuration.page_size, sort = nil)
    projection = ['_lastInform'] + Rails.configuration.index_parameters.values
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit,
      'projection' => projection.join(','),
    }
    q['sort'] = ActiveSupport::JSON.encode(sort) if sort
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/devices/?#{q.to_query}")
    @total = res['Total'].to_i
    @now = res['Date'].to_time
    return ActiveSupport::JSON.decode(res.body)
  end

  def index
    can?(:read, 'devices') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      if params.include?(:sort)
        sort_param = params[:sort].start_with?('-') ? params[:sort][1..-1] : params[:sort]
        sort_dir = params[:sort].start_with?('-') ? -1 : 1
        sort = {sort_param => sort_dir}
      else
        sort = nil
      end

      @query = {}
      if params.has_key?('query')
        @query = ActiveSupport::JSON.decode(URI.unescape(params['query']))
      end
      if request.format == Mime::CSV
        @devices = find_devices(@query, 0, 0)
      else
        @devices = find_devices(@query, skip, Rails.configuration.page_size, sort)
      end

      respond_to do |format|
        format.html # index.html.erb
        format.csv
        format.json { render json: @devices }
      end
    end
  end

  def get_files_for_device(oui, product_class)
    q = {
      'query' => ActiveSupport::JSON.encode({
        'metadata.oui' => oui,
        'metadata.productClass' => product_class}),
      'skip' => 0,
      'limit' => 10
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/files/?#{q.to_query}")
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    can?(:read, 'devices') do
      @device = get_device(params[:id])
      @device_params = flatten_params(@device)
      @files = get_files_for_device(@device['_deviceId']['_OUI'], @device['_deviceId']['_ProductClass'])
      @tasks = get_device_tasks(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @device }
      end
    end
  end

  def update
    if params.include? 'refresh_summary'
      can?(:read, 'devices/refresh_summary') do
        parameterNames = []
        objectNames = []
        for k, v in Rails.configuration.summary_parameters
          if v.is_a?(String)
            parameterNames << v
          else
            objectNames << v['_object']
          end
        end

        for o in objectNames
          task = {'name' => 'refreshObject', 'objectName' => o}
          http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
          res = http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(task))
        end
        task = {'name' => 'getParameterValues', 'parameterNames' => parameterNames}
        http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
        res = http.post("/devices/#{URI.escape(params[:id])}/tasks?timeout=3000&connection_request", ActiveSupport::JSON.encode(task))

        if res.code == '200'
          flash[:success] = 'Device refreshed'
        elsif res.code == '202'
          flash[:warning] = 'Device is offline'
        else
          flash[:error] = "Unexpected error (#{res.code})"
        end
      end
    end

    if params.include? 'add_tag'
      can?(:create, 'devices/tags') do
        tag = ActiveSupport::JSON.decode(params['add_tag']).strip
        http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
        res = http.post("/devices/#{URI.escape(params[:id])}/tags/#{tag}", nil)

        if res.code == '200'
          flash[:success] = 'Tag added'
        else
          flash[:error] = "Unexpected error (#{res.code})"
        end
      end
    end

    if params.include? 'remove_tag'
      can?(:delete, 'devices/tags') do
        tag = ActiveSupport::JSON.decode(params['remove_tag']).strip
        http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
        res = http.delete("/devices/#{URI.escape(params[:id])}/tags/#{tag}", nil)

        if res.code == '200'
          flash[:success] = 'Tag removed'
        else
          flash[:error] = "Unexpected error (#{res.code})"
        end
      end
    end

    if params.include? 'commit'
      tasks = ActiveSupport::JSON.decode(params['commit'])
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)

      tasks.each_with_index do |t, i|
        case t['name']
        when 'getParameterValues'
          action = :read
          resource = 'devices/parameters'
        when 'setParameterValues'
          action = :update
          resource = 'devices/parameters'
        when 'addObject'
          action = :create
          resource = 'devices/parameters'
        when 'deleteObject'
          action = :delete
          resource = 'devices/parameters'
        when 'reboot'
          action = :update
          resource = 'devices/reboot'
        when 'factoryReset'
          action = :update
          resource = 'devices/factory_reset'
        when 'download'
          action = :update
          resource = 'devices/download'
        else
          action = :update
          resource = 'devices'
        end

        can?(action, resource) do
          if i < tasks.count - 1
            http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(t))
          else
            res = http.post("/devices/#{URI.escape(params[:id])}/tasks?timeout=3000&connection_request", ActiveSupport::JSON.encode(t))
            if res.code == '200'
              flash[:success] = 'Tasks committed'
            elsif res.code == '202'
              flash[:warning] = 'Tasks added to queue and will be committed when device is online'
            else
              flash[:error] = "Unexpected error (#{res.code})"
            end
          end
        end
      end
    end

    #redirect_to :action => :show
    redirect_to "/devices/#{URI.escape(params[:id])}"
  end

end
