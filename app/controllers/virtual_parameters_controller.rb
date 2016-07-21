class VirtualParametersController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

  def get_virtual_parameter(id)
    query = {
      'query' => ActiveSupport::JSON.encode({'_id' => id}),
    }
    http = create_api_conn()
    res = http.get("/virtual_parameters/?#{query.to_query}")
    return ActiveSupport::JSON.decode(res.body)[0]
  end

  def find_virtual_parameters(query, skip = 0, limit = Rails.configuration.page_size)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = create_api_conn()
    res = http.get("/virtual_parameters/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /virtual_parameters
  # GET /virtual_parameters.json
  def index
    can?(:read, 'virtual_parameters') do
      filters = nil

      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0

      @virtual_parameters = find_virtual_parameters(filters, skip)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @virtual_parameters }
      end
    end
  end

  # GET /virtual_parameters/new
  # GET /virtual_parameters/new.json
  def new
    can?(:create, 'virtual_parameters') do
      @virtual_parameter = {}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @virtual_parameter }
      end
    end
  end

  # GET /virtual_parameters/1/edit
  def edit
    can?(:update, 'virtual_parameters') do
      @virtual_parameter = get_virtual_parameter(params[:id]) || {}
    end
  end

  # PUT /virtual_parameters/1
  # PUT /virtual_parameters/1.json
  def update
    can?(:update, 'virtual_parameters') do
      script = params['script']

      http = create_api_conn()
      res = http.put("/virtual_parameters/#{URI.escape(params['name'].strip)}", script)
      if res.code == '200'
        flash[:success] = 'Virtual parameter saved'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /virtual_parameters/1
  # DELETE /virtual_parameters/1.json
  def destroy
    can?(:delete, 'virtual_parameters') do
      http = create_api_conn()
      res = http.delete("/virtual_parameters/#{URI.escape(params[:id])}", nil)
      if res.code == '200'
        flash[:success] = 'Virtual parameter deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end
end
