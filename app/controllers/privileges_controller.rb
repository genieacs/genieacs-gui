class PrivilegesController < ApplicationController
  
  def create
    can?(:create, 'privileges') do
      @role = Role.find(params[:role_id])
      @privilege = @role.privileges.create(privilege_params)
      redirect_to edit_role_path(@role)
    end
  end
  
  def destroy
    can?(:delete, 'privileges') do
      @role = Role.find(params[:role_id])
      @privilege = @role.privileges.find(params['id'])
      @privilege.destroy
      redirect_to edit_role_path(@role)
    end
  end

  private
    def privilege_params
      params.require(:privilege).permit(:action, :weight, :resource)
    end
end
