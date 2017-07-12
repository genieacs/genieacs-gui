class FilesController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

  # GET /files
  # GET /files.json
  def index
    can?(:read, 'files') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : nil

      res = query_resource(create_api_conn(), 'files', nil, nil, skip, Rails.configuration.page_size)
      @files = res[:result]
      @total = res[:total]

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
      http = create_api_conn()
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
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end

  # DELETE /files/1
  # DELETE /files/1.json
  def destroy
    can?(:delete, 'files') do
      filename = params[:id]
      http = create_api_conn()
      res = http.delete("/files/#{URI.escape(filename)}", nil)
      if res.code == '200'
        flash[:success] = 'File deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_to :action => :index
    end
  end
end
