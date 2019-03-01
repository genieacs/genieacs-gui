class DevicesController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'
  require 'csv'
  include ActionController::Live

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

  def index_csv(query)
    projection = ['_lastInform'] + Rails.configuration.index_parameters.values.flatten

    response.headers['Content-Type'] = 'text/csv'

    response.stream.write(Rails.configuration.index_parameters.keys.concat(["Last inform"]).to_csv())
    query_resource(create_api_conn(), 'devices', query, projection) do |obj, index, total, timestamp|
      line = []
      Rails.configuration.index_parameters.each do |label, paths|
        value = nil
        for path in paths
          p = helpers.get_param(path, obj)
          if p != nil
            value = p.is_a?(Hash) ? p['_value'] : p
            break
          end
        end
        line << value.to_s()
      end
      line << obj['_lastInform']
      response.stream.write(line.to_csv())
    end
  ensure
    response.stream.close
  end

  def index
    can?(:read, 'devices') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : nil
      if params.include?(:sort)
        sort_param = params[:sort].start_with?('-') ? params[:sort][1..-1] : params[:sort]
        sort_dir = params[:sort].start_with?('-') ? -1 : 1
        sort = {sort_param => sort_dir}
      else
        sort = nil
      end

      @query = {}
      if params.has_key?('query')
        @query = ActiveSupport::JSON.decode(params['query'])
      end

      if request.format == Mime[:csv]
        index_csv(@query)
        return
      end

      @devices = []
      projection = ['_lastInform'] + Rails.configuration.index_parameters.values.flatten

      res = query_resource(create_api_conn(), 'devices', @query, projection, skip, Rails.configuration.page_size, sort)
      @total = res[:total]
      @now = res[:timestamp]
      @devices = res[:result]

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @devices }
      end
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    can?(:read, 'devices') do
      id = params[:id]
      create_api_conn() do |http|
        res = query_resource(http, 'devices', {'_id' => id})
        if res[:result].size != 1
          raise ActiveRecord::RecordNotFound
        end
        @now = res[:timestamp]
        @device = res[:result][0]
        @device_params = flatten_params(@device)
        @files = query_resource(http, 'files', {'metadata.oui' => @device['_deviceId']['_OUI'], 'metadata.productClass' => @device['_deviceId']['_ProductClass']}, nil, nil, 10)[:result]
        @tasks = query_resource(http, 'tasks', {'device' => id}, nil, nil, nil, {'timestamp' => 1})[:result]
        @faults = {}
        query_resource(http, 'faults', {'device' => id}) do |f|
          @faults[f['channel']] = f if f
        end
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @device }
      end
    end
  end

  def update
    http = create_api_conn()
    http.start()
    if params.include? 'refresh_summary'
      can?(:read, 'devices/refresh_summary') do
        to_refresh = ActiveSupport::JSON.decode(params['refresh_summary'])

        for o in to_refresh['objects']
          task = {'name' => 'refreshObject', 'objectName' => o}
          res = http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(task))
        end

        for o in to_refresh['custom_commands']
          task = {'name' => 'customCommand', 'command' => "#{o[16..-1]} get"}
          res = http.post("/devices/#{URI.escape(params[:id])}/tasks", ActiveSupport::JSON.encode(task))
        end

        task = {'name' => 'getParameterValues', 'parameterNames' => to_refresh['parameters']}
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

    http.finish()
    redirect_to :action => :show
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
