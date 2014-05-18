class PresetsController < ApplicationController
  require 'net/http'
  require 'json'

  def get_preset(id)
    query = {
      'query' => ActiveSupport::JSON.encode({'_id' => URI.escape(id)}),
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/presets/?#{query.to_query}")
    return ActiveSupport::JSON.decode(res.body)[0]
  end

  def find_presets(query, skip = 0, limit = 10)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/presets/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /presets
  # GET /presets.json
  def index
    can?(:read, 'presets') do
      filters = nil

      skip = params.include?(:page) ? Integer(params[:page]) * 10 : 0

      @presets = find_presets(filters, skip)

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
      @preset = get_preset(params[:id]) || {}
      # For backward compatibility
      if not @preset['precondition'].is_a?(String)
        @preset['precondition'] = @preset['precondition'].to_json
      end
    end
  end

  # PUT /presets/1
  # PUT /presets/1.json
  def update
    can?(:update, 'presets') do
      preset = {}
      preset['name'] = params['name']
      preset['weight'] = params['weight']
      preset['precondition'] = params['query']
      preset['configurations'] = ActiveSupport::JSON.decode(params['configurations'])

      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.put("/presets/#{preset['name']}", ActiveSupport::JSON.encode(preset))
      if res.code == '200'
        flash[:success] = 'Preset saved'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /presets/1
  # DELETE /presets/1.json
  def destroy
    can?(:delete, 'presets') do
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.delete("/presets/#{params[:id]}", nil)
      if res.code == '200'
        flash[:success] = 'Preset deleted'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end
end
