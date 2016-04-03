class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to telegram_path
  end

  def telegram
    puts current_user.id
    puts "dfsdfddddddddddddddddddddddddddddddddddddddddAA"
    user = User.find_by_id(current_user.id)
    puts user
     if params[:message]
        user.update(tele_chat_id: params[:message][:from][:id])
     ##  #if usersssss
          user.send_message("Ура чувак ми можем слать тебе нотифи")
        #end
        render :nothing => true, :status => :ok  
    end  
 end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end