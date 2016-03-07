class CalendarController

require "google_drive"
require 'telegram/bot'
require 'selenium-webdriver'
require_dependency 'telegram_message'
require_dependency 'online_cafe'
require_dependency 'bambolina'
require_dependency 'editor'
require_dependency 'google_auth'
require_dependency 'order'
require_dependency 'site_map_builder'

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
      total_order = Hash.new

      order_array = item['description'].split(', ')
      order_array.each do |order_position|
        single_order = Hash.new
        single_order = Order.handle_order_position(order_position)
        if single_order[:shop_name]
          shop_name = single_order[:shop_name].to_sym
          total_order[shop_name] = [] unless total_order[shop_name]
          total_order[shop_name] << single_order
        else
          puts "Неможливо обробити запит \"#{order_position}\". Відредагуйте текст замовлення!"
          Telegram.send_message("Неможливо обробити запит \"#{order_position}\". Відредагуйте текст замовлення!")
        end
      end

      total_order.each_pair do |shop_name, order_for_shop|
        executed_order = Hash.new
        executed_order = Order.execute(driver, order_for_shop, shop_name.to_s)
        unless executed_order[:error]
          GoogleServices::Table.save_order(ws, order_date, executed_order[:order_list], executed_order[:price_counter])
          puts "В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн."
          Telegram.send_message("В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
        else
          puts "Не вдалося виконате замовлення із #{shop_name.to_s}, відредагуйте його текст"
          Telegram.send_message("Не вдалося виконате замовлення, відредагуйте його текст")
        end
      end
      driver.quit
    end
  end

  def self.update_site_map
    driver = Selenium::WebDriver.for:phantomjs
    shops = Shop.all
    shops.each do |shop|
      site_map = {}
      method_name = "for_#{shop.name}".downcase.gsub(' ', '_')
      site_map = SiteMapBuild.send(method_name, driver)
      shop.update_attributes(site_map: site_map)
    end
    driver.quit
  end

end