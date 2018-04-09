# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    PaperTrail::Version.create(
      event: 'login',
      whodunnit: current_user.id,
      item_id: current_user.id,
      item_type: "Session",
      ip: current_user.current_sign_in_ip
    )
  end

  # DELETE /resource/sign_out
  def destroy
    PaperTrail::Version.create(
      event: 'logout',
      whodunnit: current_user.id,
      item_id: current_user.id,
      item_type: "Session",
      ip: current_user.current_sign_in_ip
    )
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
