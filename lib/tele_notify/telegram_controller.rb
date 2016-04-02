module TeleNotify
  module Controller
    def webhook
      if params[:message]
        user = User.create( tele_chat_id: params[:message][:from][:id] )
        if user
          user.send_message("Notifications are now active. To cancel, stop this bot in Telegram.")
        end
        render :nothing => true, :status => :ok
      end
    end
  end
end
