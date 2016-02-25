class CalendarController

require "google_drive"
require 'telegram/bot'
require 'selenium-webdriver'
require_dependency 'telegram_message'
require_dependency 'online_cafe'
#require_dependency 'bambolina'
require_dependency 'editor'
require_dependency 'google_auth'
require_dependency 'order_execute'

  def self.handle_order
    items =  GoogleServices::Calendar.get_event

    session = GoogleDrive.saved_session("config.json")
      # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
      # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]
      
    items.each do |item|
      driver = Selenium::WebDriver.for:phantomjs
      driver.manage.window.maximize

      order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
      executed_order = Hash.new
      executed_order = Order.execute(item, driver, "Bambolina")
      GoogleServices::Table.save_order(ws, order_date, executed_order[:order_list], executed_order[:price_counter])
      puts "Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн."
      #Telegram.send_message("Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
    
      driver.save_screenshot("./order_screen/screen#{order_date}.png")
      driver.quit
    end
  end

end