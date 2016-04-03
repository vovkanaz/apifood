module TeleNotify
  module Controller
    def webhook
       if params[:message]
        user = User.find_by_id(current_user.id)
        user = User.update( tele_chat_id: params[:message][:from][:id] )
        #if usersssss
          user.send_message("Ура чувак ми можем слать тебе нотифи")
        #end
        render :nothing => true, :status => :ok
      end
    end
  end
end
