class UserRolesController < ApplicationController
  
  def create
    can?(:create, 'user_roles') do
      @user = User.find(params[:user_id])
      @user_role = @user.user_roles.create(user_role_params)
      clear_permissions_cache
      redirect_to edit_user_path(@user)
    end
  end
  
  def destroy
    can?(:delete, 'user_roles') do
      @user = User.find(params[:user_id])
      @user_role = @user.user_roles.find(params['id'])
      @user_role.destroy
      clear_permissions_cache
      redirect_to edit_user_path(@user)
    end
  end

  private
    def user_role_params
      params.require(:user_role).permit(:user_id, :role_id)
    end
end
