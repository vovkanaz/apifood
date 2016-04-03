class User < ActiveRecord::Base
require 'rest-client'
APPLICATION_NAME = 'Apifood'
 validates_presence_of :tele_chat_id
 validates_uniqueness_of :tele_chat_id


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def get_events
    client = Google::APIClient.new
    client.authorization.access_token = self.oauth_token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(
        :api_method => service.events.list,
        :parameters => {
            :calendarId => 'primary',
            :maxResults => 10,
            :singleEvents => true,
            :orderBy => 'startTime',
            :timeMin => Time.now.iso8601 })

    result.data['items']
   end



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
        raise "Invalid token!"
      end
    end

    def self.send_message_to_all(text)
      success = true
       User.all.each do |user|
        success = false if !user.send_message(text)
      end
      success
    end


    def send_message(text)
      response = JSON.parse(RestClient.post(@@url + "sendMessage", chat_id: self.tele_chat_id, text: text), { symbolize_names: true })
      response[:ok]
    end

end
