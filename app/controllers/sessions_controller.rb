class SessionsController < ApplicationController
  cattr_accessor :user
  skip_before_action :authenticate_user!, only: [:create]

  def create
     self.user = User.from_omniauth(env["omniauth.auth"])
     session[:user_id] = self.user.id
     redirect_to edit_user_path(self.user)
  end

  def check_telegram_chat_id
    if self.user.tele_chat_id
      self.user = nil
      flash[:present] = "Ваш chat id для Telegram відомий. Ви можете отримувати звіти про Ваші замовлення"
      redirect_to root_path
    else
      redirect_to telegram_path
    end
  end

  def telegram
    if params[:message]
      case params[:message][:text]
      when "/start"
        update_user
      when "/help"
        help_instructions
      else
        unknown_message
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end


  private

  def chat_user
    user = User.find_by(tele_chat_id: params[:message][:from][:id])
  end

  def update_user
    success = false
    if self.user
      success = true if self.user.update(tele_chat_id: params[:message][:from][:id])
      message_text = message('./public/first_notify.txt')
      self.user.send_message(message_text) if success
      self.user = nil if success
    else
      unknown_message
    end
  end

  def help_instructions
    message_text = message('./public/help_instructions.txt')
    chat_user.send_message(message_text)
  end

  def unknown_message
    message_text = message('./public/unknown_message.txt')
    chat_user.send_message(message_text)
  end

  def message(load_path)
    lines = Array.new
    File.open(load_path, "r").each_line { |line| lines << line}
    lines.join
  end

end

