class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    @auth = request.env["omniauth.auth"]
    @token = @auth["credentials"]["token"]
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to telegram_path
  end

  def telegram

  end  

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
