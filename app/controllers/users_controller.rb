class UsersController < ApplicationController
  
  def index
    can?(:read, 'users') do
      @users = User.all
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
        redirect_to users_path
      else
        render 'new'
      end
    end
  end
  
  def update
    can?(:update, 'users') do
      @user = User.find(params['id'])
      if @user.update(user_params)
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
      redirect_to users_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
