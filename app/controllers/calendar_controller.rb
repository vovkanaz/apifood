class CalendarController < ApplicationController

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
    puts '######################'
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

    session = GoogleDrive.saved_session("config.json")
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]

    (1..ws.num_rows).each do |row|
      (1..ws.num_cols).each do |col|
      end
    end

    # Changes content of cells.
    # Changes are not sent to the server until you call ws.save().
    @items.each do |item|
      count = ws.rows.length + 1
      ws[count, 1] = item['summary']
      ws[count, 2] = item['description']
      ws.save
    end

    #ws.reload

  end

end