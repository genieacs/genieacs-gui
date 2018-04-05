# frozen_string_literal: true

require 'rubygems'
require 'zip'

class ParametersController < ApplicationController
  before_action :authorize_read, only: [:download]
  before_action :authorize_delete, only: [:delete]

  def download
    @parameters = Parameter.includes(:device).where(id: params[:ids])

    zip_config_if_needed

    send_data(
      @content,
      filename: @filename,
      type: @type,
      disposition: 'attachment'
    )
  end

  def destroy
    Parameter.find(params[:id]).destroy
    redirect_to(cpe_configs_path)
  end

  private

  def zip_config_if_needed
    if @parameters.count > 1
      @filename = 'configs.zip'
      @type = :zip
      @content = zip(@parameters)
    else
      parameter = @parameters.first
      @filename = "#{parameter.device.info['_SerialNumber']}-config.json"
      @type = :json
      @content = parameter.parameters.to_json
    end
  end

  def zip(parameters)
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      parameters.each do |parameter|
        filename = "#{parameter.device.info['_SerialNumber']}-config.json"
        content = parameter.parameters.to_json
        zos.put_next_entry filename
        zos.write content
      end
    end
    compressed_filestream.string
  end

  def authorize_read
    raise NotAuthorized unless can?(:read, 'cpe_configs')
  end

  def authorize_delete
    raise NotAuthorized unless can?(:delete, 'cpe_configs')
  end
end
