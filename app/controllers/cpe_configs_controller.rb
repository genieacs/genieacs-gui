# frozen_string_literal: true

class CpeConfigsController < ApplicationController
  before_action :authorize
  before_action :set_date

  def index
    @page = params[:page] || 1
    @total = Parameter.count
    @parameters = @parameters.includes(:device).page(@page).to_a
  end

  private

  def authorize
    raise NotAuthorized unless can?(:read, 'cpe_configs')
  end

  def set_date
    @parameters = Parameter

    return if params[:start_date].blank? || params[:end_date].blank?

    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @parameters = @parameters.by_date(@start_date, @end_date)
  end
end
