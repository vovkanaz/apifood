module Calendar
  class Events
    require 'google/api_client'
    require 'google/api_client/client_secrets'
    require 'google/api_client/auth/installed_app'
    require 'google/api_client/auth/storage'
    require 'google/api_client/auth/storages/file_store'
    require 'fileutils'

    APPLICATION_NAME = 'Apifood'
    CLIENT_SECRETS_PATH = 'client_secrets.json'
    CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                                 "calendar-ruby-quickstart.json")
    SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'

    def self.get_data
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

      file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
      storage = Google::APIClient::Storage.new(file_store)
      auth = storage.authorize

      if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
        app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
        flow = Google::APIClient::InstalledAppFlow.new({
                                                           :client_id => app_info.client_id,
                                                           :client_secret => app_info.client_secret,
                                                           :scope => SCOPE})
        auth = flow.authorize(storage)
        puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
      end


# Initialize the API
      client = Google::APIClient.new(:application_name => APPLICATION_NAME)
      client.authorization = auth
      calendar_api = client.discovered_api('calendar', 'v3')

# Fetch the next 10 events for the user
      results = client.execute!(
          :api_method => calendar_api.events.list,
          :parameters => {
              :calendarId => 'primary',
              :maxResults => 10,
              :singleEvents => true,
              :orderBy => 'startTime',
              :timeMin => Time.now.iso8601 })

      puts "No upcoming events found" if results.data.items.empty?
      results.data['items']
    end
  end
end
