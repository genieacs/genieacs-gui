class LogsController < ApplicationController
  def index
    can?(:read, 'logs') do
      off = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      lim = Rails.configuration.page_size
      @logs = PaperTrail::Version.order(created_at: :desc)

      @total = @logs.count
      @logs = @logs.limit(lim).offset(off)
    end

  end
end
