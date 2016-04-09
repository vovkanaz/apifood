class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
     user = User.from_omniauth(env["omniauth.auth"])
     session[:user_id] = user.id
     redirect_to edit_user_path(User.where(name: current_user.name).first)
  end

  def telegram
     if params[:message]
        puts "-------------------------------------"  
        user = User.find_by(current_user)
        puts "============================================"  
        user.update(tele_chat_id: params[:message][:from][:id])
        puts "_________________________________________________"  
        user.send_message("Тепер ми можемо слати нотіфі!!! Для допомги по роботі з ботом відішліть боту команду /help")
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end