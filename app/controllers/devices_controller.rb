class DevicesController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

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
    http = create_api_conn()
    res = http.get("/devices/?#{query.to_query}")
    @now = res['Date'].to_time
    return ActiveSupport::JSON.decode(res.body)[0]
  end

  def get_device_tasks(device_id)
    query = {
      'query' => ActiveSupport::JSON.encode({'device' => device_id}),
      'sort' => ActiveSupport::JSON.encode({'timestamp' => 1})
    }
    http = create_api_conn()
    res = http.get("/tasks/?#{query.to_query}")
    return ActiveSupport::JSON.decode(res.body)
  end

  def find_devices(query, skip = nil, limit = nil, sort = nil)
    projection = ['_lastInform'] + Rails.configuration.index_parameters.values
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'projection' => projection.join(','),
    }

    q['skip'] = skip if skip
    q['limit'] = limit if limit
    q['sort'] = ActiveSupport::JSON.encode(sort) if sort
    http = create_api_conn()
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
        @devices = find_devices(@query)
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
    http = create_api_conn()
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
        to_refresh = ActiveSupport::JSON.decode(params['refresh_summary'])

        for o in to_refresh['objects']
          task = {'name' => 'refreshObject', 'objectName' => o}
          http = create_api_conn()
          res = http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(task))
        end

        for o in to_refresh['custom_commands']
          task = {'name' => 'customCommand', 'command' => "#{o[16..-1]} get"}
          http = create_api_conn()
          res = http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(task))
        end

        task = {'name' => 'getParameterValues', 'parameterNames' => to_refresh['parameters']}
        http = create_api_conn()
        res = http.post("/devices/#{URI.escape(params[:id])}/tasks?timeout=3000&connection_request", ActiveSupport::JSON.encode(task))

        if res.code == '200'
          flash[:success] = 'Device refreshed'
        elsif res.code == '202'
          flash[:warning] = res.message
        else
          flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
        end
      end
    end

    if params.include? 'add_tag'
      can?(:create, 'devices/tags') do
        tag = ActiveSupport::JSON.decode(params['add_tag']).strip
        http = create_api_conn()
        res = http.post("/devices/#{URI.escape(params[:id])}/tags/#{URI::escape(tag)}", nil)

        if res.code == '200'
          flash[:success] = 'Tag added'
        else
          flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
        end
      end
    end

    if params.include? 'remove_tag'
      can?(:delete, 'devices/tags') do
        tag = ActiveSupport::JSON.decode(params['remove_tag']).strip
        http = create_api_conn()
        res = http.delete("/devices/#{URI.escape(params[:id])}/tags/#{URI::escape(tag)}", nil)

        if res.code == '200'
          flash[:success] = 'Tag removed'
        else
          flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
        end
      end
    end

    if params.include? 'commit'
      tasks = ActiveSupport::JSON.decode(params['commit'])
      http = create_api_conn()

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
              flash[:warning] = res.message
            else
              flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
            end
          end
        end
      end
    end

    #redirect_to :action => :show
    redirect_to "/devices/#{URI.escape(params[:id])}"
  end

  def destroy
    can?(:delete, '/devices/') do
      http = create_api_conn()
      res = http.delete("/devices/#{URI::escape(params[:id])}")
      if res.code != '200'
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end
    end

    redirect_to :controller => 'devices', :action => 'index'
  end

end
