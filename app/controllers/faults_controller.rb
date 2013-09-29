class FaultsController < ApplicationController
  require 'net/http'
  require 'json'

  def find_faults(query, skip = 0, limit = 0)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.get("/tasks/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /faults
  # GET /faults.json
  def index
    skip = params.include?(:page) ? (Integer(params[:page]) - 1) * 30 : 0
    @query = {}
    @query = ActiveSupport::JSON.decode(URI.unescape(params['query'])) if params.has_key?('query')
    @query['fault'] = {'$exists' => 1}
    @faults = find_faults(@query, skip, 30)
    @query.delete('fault')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @faults }
    end
  end

  # POST /faults/:id/retry
  def retry
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.post("/tasks/#{params[:id]}/retry", nil)
    if res.code == '200'
      flash[:success] = 'Task updated'
    else
      flash[:error] = "Unexpected error (#{res.code})"
    end

    redirect_to :back
  end

  # DELETE /faults/1
  # DELETE /faults/1.json
  def destroy
    http = Net::HTTP.new(Rails.configuration.genieacs_api_host, Rails.configuration.genieacs_api_port)
    res = http.delete("/tasks/#{params[:id]}", nil)
    if res.code == '200'
      flash[:success] = 'Faulty task deleted'
    else
      flash[:error] = "Unexpected error (#{res.code})"
    end

    redirect_to :back
  end
end
