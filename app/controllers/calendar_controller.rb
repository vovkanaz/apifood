class CalendarController < ApplicationController
 require 'google/api_client'



 def google_drive_connect
   api_client = ::Google::APIClient.new(application_name: 'ApiFOOD', application_version: '2.0')
   api_client.authorization.client_id = '1022710274932-2d5it0ja1sc0k0pihnq59hocbcu5h4lk.apps.googleusercontent.com'
   api_client.authorization.client_secret = '64pMMvaQ-5BBGcqH5hCqOyn2'
   api_client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'
   api_client.authorization.redirect_uri = 'http://localhost:3000/calendar/callback'
   auth_uri = api_client.authorization.authorization_uri(access_type: 'offline', approval_prompt: :force).to_s
   redirect_to auth_uri
 end

 def callback
   api_client = ::Google::APIClient.new(application_name: 'ApiFOOD', application_version: '2.0')
   api_client.authorization.client_id = '1022710274932-2d5it0ja1sc0k0pihnq59hocbcu5h4lk.apps.googleusercontent.com'
   api_client.authorization.client_secret = '64pMMvaQ-5BBGcqH5hCqOyn2'
   api_client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'
   api_client.authorization.redirect_uri = 'http://localhost:3000/calendar/callback'
   api_client.authorization.code = params['code']
   session[:access_token] = api_client.authorization.fetch_access_token!['access_token']
   redirect_to url_for(:action => :index)

 end

  def index
    api_client = ::Google::APIClient.new(application_name: 'ApiFOOD', application_version: '2.0')
    api_client.authorization.client_id = '1022710274932-2d5it0ja1sc0k0pihnq59hocbcu5h4lk.apps.googleusercontent.com'
    api_client.authorization.client_secret = '64pMMvaQ-5BBGcqH5hCqOyn2'
    api_client.authorization.access_token = session[:access_token]
    puts api_client.authorization.access_token
    calendar_api = api_client.discovered_api('calendar', 'v3')

    results = api_client.execute!(
        :api_method => calendar_api.events.list,
        :parameters => {
            :calendarId => 'primary',
            :maxResults => 10,
            :singleEvents => true,
            :orderBy => 'startTime',
            :timeMin => Time.now.iso8601 })

    @items = results.data['items']

  end

end