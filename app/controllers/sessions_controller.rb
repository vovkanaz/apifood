class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    @auth = request.env["omniauth.auth"]
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(
        :api_method => service.events.list,
        :parameters => {
            :calendarId => 'primary',
            :maxResults => 10,
            :singleEvents => true,
            :orderBy => 'startTime',
            :timeMin => Time.now.iso8601 })

    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    @events = result.data['items']
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
