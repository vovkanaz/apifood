require 'rest-client'

module TeleNotify
  class TelegramUser < ::ActiveRecord::Base

    validates_presence_of :telegram_id
    validates_uniqueness_of :telegram_id

    @@next_update_id = 0

    def self.configure_home_url(url)
      @@home_url = url
    end

    def self.configure_dev_url(url)
      @@dev_url = url
    end

    def self.active_url
      if Rails.env.production?
        @@home_url
      else
        @@dev_url
      end
    end


    def self.configure_token(token)
      if token =~ /^[0-9]+:[\w-]+$/ #hacker proof
        @@token = token
        @@url = "https://api.telegram.org/bot" + token + "/"
        @@callback_url = active_url + "/" + @@token
        RestClient.post(@@url + "setWebhook", { url: @@callback_url })
      else
        raise "Invalid token! Please add a valid Telegram token in config/initializers/tele_notify.rb or see https://github.com/ppati000/tele_notify for further instructions."
      end
    end

    def self.send_message_to_all(text)
      success = true
      TeleNotify::TelegramUser.all.each do |user|
        success = false if !user.send_message(text)
      end
      success
    end


    def send_message(text)
      response = JSON.parse(RestClient.post(@@url + "sendMessage", chat_id: self.telegram_id, text: text), { symbolize_names: true })
      response[:ok]
    end


  end

end
