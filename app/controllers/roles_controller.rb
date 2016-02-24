class RolesController < ApplicationController
  
  def index
    @roles = Role.all
    @total = Role.count
  end
  
  def new
    @role = Role.new
  end
  
  def edit
    @role = Role.find(params['id'])
    @total = @role.privileges.count
  end
  
  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path
    else
      render 'new'
    end
  end
  
  def update
    @role = Role.find(params['id'])
    if @role.update(role_params)
      redirect_to roles_path
    else
        render 'edit'
    end
  end
  
  def destroy
    @role = Role.find(params['id'])
    @role.destroy
    redirect_to roles_path
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end
end
