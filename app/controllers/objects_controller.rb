class ObjectsController < ApplicationController
  require 'net/http'
  require 'json'

  def get_object(id)
    query = {
      'query' => ActiveSupport::JSON.encode({'_id' => URI.escape(id)}),
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/objects/?#{query.to_query}")
    return ActiveSupport::JSON.decode(res.body)[0]
  end

  def find_objects(query, skip = 0, limit = 10)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/objects/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /objects
  # GET /objects.json
  def index
    can?(:read, 'objects') do
      filters = nil

      skip = params.include?(:page) ? Integer(params[:page]) * 10 : 0

      @objects = find_objects(filters, skip)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @objects }
      end
    end
  end

  # GET /objects/new
  # GET /objects/new.json
  def new
    can?(:create, 'objects') do
      @object = {}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @object }
      end
    end
  end

  # GET /objects/1/edit
  def edit
    can?(:update, 'objects') do
      @object = get_object(params[:id]) || {}
    end
  end

  # PUT /objects/1
  # PUT /objects/1.json
  def update
    can?(:update, 'objects') do
      objectName = params['name']
      object = ActiveSupport::JSON.decode(params['parameters'])

      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.put("/objects/#{objectName}", ActiveSupport::JSON.encode(object))
      if res.code == '200'
        flash[:success] = 'Object saved'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /objects/1
  # DELETE /objects/1.json
  def destroy
    can?(:delete, 'objects') do
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.delete("/objects/#{params[:id]}", nil)
      if res.code == '200'
        flash[:success] = 'Object deleted'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end
end
