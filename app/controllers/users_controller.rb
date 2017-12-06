class UsersController < ApplicationController
  
  def index
    can?(:read, 'users') do
      off = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      lim = Rails.configuration.page_size
      @users = User.limit(lim).offset(off)
      @total = User.count
    end
  end
  
  def new
    can?(:create, 'users') do
      @user = User.new
    end
  end
  
  def edit
    can?(:update, 'users') do
      @user = User.find(params['id'])
    end
  end
  
  def create
    can?(:create, 'users') do
      @user = User.new(user_params)
      if @user.save
        clear_permissions_cache
        redirect_to users_path
      else
        render 'new'
      end
    end
  end
  
  def update
    can?(:update, 'users') do
      @user = User.find(params['id'])
      if user_params['password'].blank?
        params['user'].delete('password')
      end

      if @user.update(user_params)
        clear_permissions_cache
        redirect_to users_path
      else
          render 'edit'
      end
    end
  end
  
  def destroy
    can?(:delete, 'users') do
      @user = User.find(params['id'])
      @user.destroy
      clear_permissions_cache
      redirect_to users_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
