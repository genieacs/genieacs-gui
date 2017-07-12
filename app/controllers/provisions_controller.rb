class ProvisionsController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

  # GET /provisions
  # GET /provisions.json
  def index
    can?(:read, 'provisions') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : nil

      res = query_resource(create_api_conn(), 'provisions', nil, nil, skip, Rails.configuration.page_size)
      @provisions = res[:result]
      @total = res[:total]

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @provisions }
      end
    end
  end

  # GET /provisions/new
  # GET /provisions/new.json
  def new
    can?(:create, 'provisions') do
      @provision = {}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @provision }
      end
    end
  end

  # GET /provisions/1/edit
  def edit
    can?(:update, 'provisions') do
      id = params[:id]
      res = query_resource(create_api_conn(), 'provisions', {'_id' => id})
      @provision = res[:result][0] || {}
    end
  end

  # PUT /provisions/1
  # PUT /provisions/1.json
  def update
    can?(:update, 'provisions') do
      script = params['script']

      http = create_api_conn()
      res = http.put("/provisions/#{URI.escape(params['name'].strip)}", script)
      if res.code == '200'
        flash[:success] = 'Provision saved'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /provisions/1
  # DELETE /provisions/1.json
  def destroy
    can?(:delete, 'provisions') do
      http = create_api_conn()
      res = http.delete("/provisions/#{URI.escape(params[:id])}", nil)
      if res.code == '200'
        flash[:success] = 'Provision deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end
end
