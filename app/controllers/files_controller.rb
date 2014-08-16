class FilesController < ApplicationController
  require 'net/http'
  require 'json'

  def find_files(query, skip = 0, limit = Rails.configuration.page_size)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/files/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /files
  # GET /files.json
  def index
    can?(:read, 'files') do
      filters = nil

      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0

      @files = find_files(filters, skip)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @files }
      end
    end
  end

  # GET /files/new
  # GET /files/new.json
  def new
    can?(:create, 'files') do
      @file = {}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @file }
      end
    end
  end

  # POST /files
  def upload
    can?(:create, 'files') do
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      req = Net::HTTP::Put.new("/files/#{URI.escape(params[:file].original_filename)}")
      req.body = params[:file].read
      req['fileType'] = params[:file_type].strip
      req['oui'] = params[:oui].strip
      req['productClass'] = params[:product_class].strip
      req['version'] = params[:version].strip
      res = http.request(req)

      if res.code == '201'
        flash[:success] = 'File saved'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /files/1
  # DELETE /files/1.json
  def destroy
    can?(:delete, 'files') do
      filename = [params[:id], params[:format]].compact.join('.')
      http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
      res = http.delete("/files/#{URI.escape(filename)}", nil)
      if res.code == '200'
        flash[:success] = 'File deleted'
      else
        flash[:error] = "Unexpected error (#{res.code})"
      end

      redirect_to :action => :index
    end
  end
end
