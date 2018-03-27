class CustomFailureApp < Devise::FailureApp
  def redirect
    store_location!
    message = warden.message || warden_options[:message]
    if message == :timeout
      flash[:error] = "User is expired."
      redirect_to new_user_session_path
    else
      super
    end
  end
end