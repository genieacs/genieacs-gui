class LogsController < ApplicationController
  def index
    can?(:read, 'logs') do
      off = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      lim = Rails.configuration.page_size
      @logs = PaperTrail::Version

      @filter_from = params[:from]
      @filter_to = params[:to]

      if @filter_from.present? && @filter_to.present?
        @logs = @logs.where('created_at::timestamp::date BETWEEN ? AND ?', @filter_from, @filter_to)
      elsif @filter_from.present?
        @logs = @logs.where('created_at::timestamp::date >= ?', @filter_from)
      elsif @filter_to.present?
        @logs = @logs.where('created_at::timestamp::date <= ?', @filter_to)
      end

      @logs = @logs.order(created_at: :desc)
      @total = @logs.count
      @logs = @logs.limit(lim).offset(off)
    end
  end
end
