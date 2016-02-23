class CalendarController

require "google_drive"
require 'telegram/bot'
require 'selenium-webdriver'
require_dependency 'online_cafe'
require_dependency 'telegram_message'
require_dependency 'editor'
require_dependency 'google_auth'

  def self.handle_order
    @items =  Calendar::Events.get_data

    session = GoogleDrive.saved_session("config.json")
      # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
      # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]

    driver = Selenium::WebDriver.for:phantomjs
    driver.manage.window.maximize
      d = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
      price_counter = 0
      order_list = []
      @items.each do |item|
        total_order = item['description'].split(',')
        total_order.each do |order_position|
          order = []
          order = params_for_order(order_position)
          dish_name = Editor.delete_needless_symbols(order.first)
          puts dish_name
          dishes_number = order.last
          puts dishes_number
          price_counter += OnlineCafe.add_order(driver, dish_name, dishes_number)*dishes_number
         order_list << "#{dish_name} --> #{dishes_number}"
        end
        count = ws.rows.length + 1
        ws[count, 1] = d
        ws[count, 2] = order_list.join(', ')
        ws[count, 3] = "#{price_counter} грн."
        ws.save
        order = item['description']
        TelegramMessageService.instance.send("Вы замовили #{order_list.join(', ')} на суму #{price_counter} грн.")
      end
    OnlineCafe.send_checkout_form(driver, "First name", "Last name", "Company", "Customer adress", "Room 123", "customer_email@example.com", "0931234567")
    driver.save_screenshot("./order_screen/screen#{d}.png")
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