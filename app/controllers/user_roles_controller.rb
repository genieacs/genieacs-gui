class UserRolesController < ApplicationController
  
  def create
    @user = User.find(params[:user_id])
    @user_role = @user.user_roles.create(user_role_params)
    redirect_to edit_user_path(@user)
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @user_role = @user.user_roles.find(params['id'])
    @user_role.destroy
    redirect_to edit_user_path(@user)
  end

  private
    def user_role_params
      params.require(:user_role).permit(:user_id, :role_id)
    end
end
