class RolesController < ApplicationController
  
  def index
    can?(:read, 'roles') do
      @roles = Role.all
      @total = Role.count
    end
  end
  
  def new
    can?(:create, 'roles') do
      @role = Role.new
    end
  end
  
  def edit
    can?(:update, 'roles') do
      @role = Role.find(params['id'])
      @total = @role.privileges.count
    end
  end
  
  def create
    can?(:create, 'roles') do
      @role = Role.new(role_params)
      if @role.save
        redirect_to roles_path
      else
        render 'new'
      end
    end
  end
  
  def update
    can?(:update, 'roles') do
      @role = Role.find(params['id'])
      if @role.update(role_params)
        redirect_to roles_path
      else
          render 'edit'
      end
    end
  end
  
  def destroy
    can?(:delete, 'roles') do
      @role = Role.find(params['id'])
      @role.destroy
      redirect_to roles_path
    end
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end
end
