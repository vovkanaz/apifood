module TeleNotify
  module Controller
    def webhook
      if params[:message]
        #user = User.create( tele_chat_id: params[:message][:from][:id] )
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        user = User.from_omniauth(env["omniauth.auth"])
        #user = User.find_by_id(:id)
        user = User.update( tele_chat_id: params[:message][:from][:id] )
        #if usersssss
          user.send_message("Ура чувак ми можем слать тебе нотифи")
        #end
        render :nothing => true, :status => :ok
      end
    end
  end
end
