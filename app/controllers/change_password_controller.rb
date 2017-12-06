class ChangePasswordController < ApplicationController

  def index
  end

  def update
    user = User.find_by username: params['username']
    if not user
      flash[:error] = "Incorrect username or password"
      redirect_to change_password_path
      return
    end

    if user['password'] != params['old_password']
      flash[:error] = "Incorrect username or password"
      redirect_to change_password_path
      return
    end

    if not user.update(password: params['new_password'])
      flash[:error] = user.errors.full_messages.join('; ')
      redirect_to change_password_path
      return
    else
      clear_permissions_cache
    end

    flash[:success] = 'Password successfully changed'
    redirect_to root_path
  end
end
