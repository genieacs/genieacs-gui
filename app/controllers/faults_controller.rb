class FaultsController < ApplicationController
  require 'net/http'
  require 'json'
  require 'util'

  def find_faults(query, skip = 0, limit = Rails.configuration.page_size)
    q = {
      'query' => ActiveSupport::JSON.encode(query),
      'skip' => skip,
      'limit' => limit
    }
    http = create_api_conn()
    res = http.get("/faults/?#{q.to_query}")
    @total = res['Total'].to_i
    return ActiveSupport::JSON.decode(res.body)
  end

  # GET /faults
  # GET /faults.json
  def index
    can?(:read, 'faults') do
      skip = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      if params.has_key?('query')
        @query = ActiveSupport::JSON.decode(URI.unescape(params['query']))
      else
        @query = {}
      end

      @faults = find_faults(@query, skip, Rails.configuration.page_size)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @faults }
      end
    end
  end

  # DELETE /faults/1
  # DELETE /faults/1.json
  def destroy
    can?(:delete, 'faults') do
      http = create_api_conn()
      res = http.delete("/faults/#{URI.escape(params[:id])}", nil)
      if res.code == '200'
        flash[:success] = 'Fault deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_back(fallback_location: root_path)
    end
  end

  # POST /tasks/:id/retry
  def retry_task
    can?(:update, 'tasks/retry') do
      http = create_api_conn()
      res = http.post("/tasks/#{params[:id]}/retry", nil)
      if res.code == '200'
        flash[:success] = 'Task updated'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_back(fallback_location: root_path)
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy_task
    can?(:delete, 'tasks') do
      http = create_api_conn()
      res = http.delete("/tasks/#{params[:id]}", nil)
      if res.code == '200'
        flash[:success] = 'Faulty task deleted'
      else
        flash[:error] = "Unexpected error (#{res.code}): #{res.body}"
      end

      redirect_back(fallback_location: root_path)
    end
  end
end
