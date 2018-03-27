class UsersController < ApplicationController

  def index
    can?(:read, 'users') do
      off = params.include?(:page) ? (Integer(params[:page]) - 1) * Rails.configuration.page_size : 0
      lim = Rails.configuration.page_size
      load_users

      @users = @users.limit(lim).offset(off)
      @total = @users.count
    end
  end

  def new
    can?(:create, 'users') do
      @user = User.new
    end
  end

  def edit
    can?(:update, 'users') do
      load_user
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
      load_user
      if user_params['password'].blank?
        params['user'].delete('password')
      end

      if @user.update(user_params)
        redirect_to users_path
      else
          render 'edit'
      end
    end
  end

  def destroy
    can?(:delete, 'users') do
      load_user
      @user.destroy
      redirect_to users_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :expired_at)
    end

    def load_users
      role = current_user.roles.pluck(:id).max
      @users = User.left_outer_joins(:roles).where('roles.id < ? OR roles is null', role)
    end

    def load_user
      role = current_user.roles.pluck(:id).max
      @user = User.left_outer_joins(:roles).where('roles.id < ? OR roles is null', role).find(params[:id])
    end
end
