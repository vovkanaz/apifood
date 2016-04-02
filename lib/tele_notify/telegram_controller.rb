module TeleNotify
  module Controller
    def webhook
      if params[:message]
        #user = User.create( tele_chat_id: params[:message][:from][:id] )
        user = User.update_all( tele_chat_id: params[:message][:from][:id] )
        if user
          user.send_message("Ура чувак ми можем слать тебе нотифи")
        end
        render :nothing => true, :status => :ok
      end
    end
  end
end
