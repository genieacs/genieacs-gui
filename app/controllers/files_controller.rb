class FilesController < ApplicationController
  require 'net/http'
  require 'json'

  def self.find_files(query, skip = 0, limit = 10)
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
    filters = nil
    
    skip = params.include?(:page) ? Integer(params[:page]) * 10 : 0

    @files = FilesController.find_files(filters, skip)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @files }
    end
  end

  # GET /files/new
  # GET /files/new.json
  def new
    @file = {}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @file }
    end
  end

  # POST /files
  def upload
    uploaded_io = params[:file]
    file = {}
    file['name'] = uploaded_io.original_filename

    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.put("/files/#{uploaded_io.original_filename}", uploaded_io.read)
    if res.code == '201'
      flash[:success] = 'File saved'
    else
      flash[:error] = "Unexpected error (#{res.code})"
    end

    redirect_to :action => :index
  end

  # DELETE /files/1
  # DELETE /files/1.json
  def destroy
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.delete("/files/#{params[:id]}", nil)
    if res.code == '200'
      flash[:success] = 'File deleted'
    else
      flash[:error] = "Unexpected error (#{res.code})"
    end

    redirect_to :action => :index
  end
end
