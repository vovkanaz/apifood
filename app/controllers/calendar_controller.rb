class CalendarController 


require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'
require "google_drive"
require 'telegram/bot'
require 'selenium-webdriver'
require_dependency 'online_cafe'
require_dependency 'telegram_message'

APPLICATION_NAME = 'Apifood'
CLIENT_SECRETS_PATH = 'client_secrets.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.json")
SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# If authorization is required, the user's default browser will be launched
# to approve the request.
#
# @return [Signet::OAuth2::Client] OAuth2 credentials
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

    @items = results.data['items']

    session = GoogleDrive.saved_session("config.json")
      # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
      # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]

    driver = Selenium::WebDriver.for:phantomjs
    driver.manage.window.maximize

      price_counter = 0
      order_list = []
      @items.each do |item|
        total_order = item['description'].split(',')
        total_order.each do |order_position|
          order = []
          order = params_for_order(order_position)
          price_counter += OnlineCafe.add_order(driver, order.first, order.last)*order.last
         order_list << "#{order.first} --> #{order.last}"
        end
        d = DateTime.now
        count = ws.rows.length + 1
        ws[count, 1] = d.strftime('%m.%d.%Y в %I:%M%p')
        ws[count, 2] = order_list.join(', ')
        ws[count, 3] = "#{price_counter} грн."
        ws.save
        order = item['description']
        #TelegramMessageService.instance.send("Вы заказали #{order} на суму #{price_counter} грн.")
      end
    OnlineCafe.send_checkout_form(driver, "First name", "Last name", "Company", "Customer adress", "Room 123", "customer_email@example.com", "0931234567")
    driver.save_screenshot("./order_screen/screen#{d.strftime('%m.%d.%Y в %I:%M%p')}.png")
    driver.quit
  end

  private

  def self.params_for_order(order_position)
      order_array = []
      dishes_number = order_position.split.last
      if dishes_number.to_i != 0
        dish = (order_position.split - dishes_number.split).join(' ')
        order_array << dish.squish << dishes_number.to_i
      else
        order_array << order_position.squish << 1
      end
  end

end