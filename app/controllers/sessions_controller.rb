class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
     user = User.from_omniauth(env["omniauth.auth"])
     session[:user_id] = user.id
     redirect_to edit_user_path(User.where(name: current_user.name).first)
  end

  def telegram
     if params[:message]
        user = User.find_by(current_user)
        puts "============================================"
        if user.tele_chat_id     
          user.update(tele_chat_id: params[:message][:from][:id])
          #user.send_message("Тепер я можу слати вам повідомлення!!! Для допомги по роботі з ботом відішліть боту команду /help")
        else
          flash[:good] = "У нас е вже твий чат ид"
          redirect_to telegram_path
        end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end