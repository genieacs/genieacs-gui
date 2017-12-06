class RolesController < ApplicationController
  
  def index
    can?(:read, 'roles') do
      off = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      lim = Rails.configuration.page_size
      @roles = Role.limit(lim).offset(off)
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
        clear_permissions_cache
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
        clear_permissions_cache
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
      clear_permissions_cache
      redirect_to roles_path
    end
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end
end
