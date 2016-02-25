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
      order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
      price_counter = 0
      order_list = Array.new
      @items.each do |item|
        total_order = item['description'].split(', ')
        total_order.each do |order_position|
          order = Hash.new
          order = params_for_order(order_position)
          puts order[:dish_name]
          puts order[:dish_number]
          module_respond = OnlineCafe.add_order(driver, order[:dish_name], order[:dish_number])
          puts module_respond
          unless module_respond[:error]
            price_counter += module_respond[:price] * order[:dish_number]
            order_list << "#{order[:dish_name]} --> #{order[:dish_number]}"
          else
            puts "Неможливо обробити запит \"#{order[:dish_name]}\". Відредагуйте текст замовлення!"
            #Telegram.send_message("Неможливо обробити запит \"#{order[:dish_name]}\". Відредагуйте текст замовлення!")
          end
        end
        count = ws.rows.length + 1
        ws[count, 1] = order_date
        ws[count, 2] = order_list.join(', ')
        ws[count, 3] = "#{price_counter} грн."
        ws.save
        puts "Ви замовили #{order_list.join(', ')} на суму #{price_counter} грн."
        #Telegram.send_message("Ви замовили \"#{order_list.join(', ')}\" на суму #{price_counter} грн.")
      end
    OnlineCafe.send_checkout_form(driver, "First name", "Last name", "Company", "Customer adress", "Room 123", "customer_email@example.com", "0931234567")
    driver.save_screenshot("./order_screen/screen#{order_date}.png")
    driver.quit
  end

  private

  def self.params_for_order(order_position)
      order_hash = Hash.new
      dishes_number = order_position.split.last
      if dishes_number.to_i != 0
        dish_name = (order_position.split - dishes_number.split).join(' ')
        order_hash = { dish_name: dish_name.squish, dish_number: dishes_number.to_i }
      else
        order_hash = { dish_name: order_position.squish, dish_number: 1 }
      end
  end

end