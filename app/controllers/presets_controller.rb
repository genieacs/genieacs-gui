class PresetsController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

  def events_to_string(events)
    begin
      events.collect {|k,v| "#{'-' if not v}#{k}"}.join(', ')
    rescue
      ''
    end
  end

  def events_to_object(events)
    obj = {}
    events.split(',').each do |v|
      v.strip!
      if v[0] == '-'
        obj[v[1..-1].strip] = false
      else
        obj[v] = true
      end
    end
    return obj
  end

  helper_method :events_to_object
  helper_method :events_to_string

  # GET /presets
  # GET /presets.json
  def index
    can?(:read, 'presets') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : nil

      res = query_resource(create_api_conn(), 'presets', nil, nil, skip, Rails.configuration.page_size)
      @presets = res[:result]
      @total = res[:total]

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @presets }
      end
    end
  end

  # GET /presets/new
  # GET /presets/new.json
  def new
    can?(:create, 'presets') do
      @preset = {}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @preset }
      end
    end
  end

  # GET /presets/1/edit
  def edit
    can?(:update, 'presets') do
      id = params[:id]
      res = query_resource(create_api_conn(), 'presets', {'_id' => id})
      @preset = res[:result][0] || {}
    end
  end

  # PUT /presets/1
  # PUT /presets/1.json
  def update
    can?(:update, 'presets') do
      preset = {}
      preset['channel'] = params['channel']
      preset['weight'] = params['weight'].to_i
      preset['precondition'] = params['query']
      preset['configurations'] = ActiveSupport::JSON.decode(params['configurations'])
      preset['schedule'] = params['schedule']
      preset['events'] = events_to_object(params['events'])

      http = create_api_conn()
      res = http.put("/presets/#{URI.escape(params['name'].strip)}", ActiveSupport::JSON.encode(preset))
      if res.code == '200'
        flash[:success] = 'Preset saved'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /presets/1
  # DELETE /presets/1.json
  def destroy
    can?(:delete, 'presets') do
      http = create_api_conn()
      res = http.delete("/presets/#{URI.escape(params[:id])}", nil)
      if res.code == '200'
        flash[:success] = 'Preset deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end
end
