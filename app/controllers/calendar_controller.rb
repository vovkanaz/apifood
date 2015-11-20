class CalendarController < ApplicationController
 require 'google/api_client'
 def index

 end

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
   api_client.authorization.fetch_access_token!
   url = 'https://www.googleapis.com/oauth2/v2/userinfo?access_token='; + api_client.authorization.access_token.to_s
   json = JSON.parse(open(url).read)

   @user.authentication_document = AuthenticationDocument.new({
                                                                  token: api_client.authorization.access_token,
                                                                  refresh_token: api_client.authorization.refresh_token,
                                                                  expires_at: Time.now + api_client.authorization.expires_in
                                                              })
 end
end