class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    if (Rails.configuration.users[params[:username]]['password'].to_s == params[:password] rescue false)
      session[:username] = params[:username]
      redirect_to params[:url]
    else
      flash.now.alert = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    session[:username] = nil
    redirect_to root_path
  end

end
