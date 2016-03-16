class User < ActiveRecord::Base
  APPLICATION_NAME = 'Apifood'

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

    if result.data.items.empty?
      {}
    else
   result.data['items']
    end
  end
end
