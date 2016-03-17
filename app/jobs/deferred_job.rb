class DeferredJob < ActiveJob::Base
  queue_as :default
  require 'google/api_client'
  require 'google_drive'
  require 'selenium-webdriver'
  require_dependency 'telegram_message'
  require_dependency 'online_cafe'
  require_dependency 'bambolina'
  require_dependency 'editor'
  require_dependency 'google_auth'
  require_dependency 'order'
  require_dependency 'sessions_controller'

    def perform
     #session = GoogleDrive.saved_session("config.json")
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
     #ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]

     User.where.not(oauth_token: nil).each do |user|
      google_drive_session = GoogleDrive.login_with_oauth(user.oauth_token)
    
      spreadsheet = google_drive_session.create_spreadsheet(title = "Food")
      ws = spreadsheet.worksheets[0]
      ws[1, 1] = "Дата"
      ws[1, 2] = "Заказ"
      ws[1, 3] = "Сумма"
      ws.save
      #Telegram.send_message(user.get_events)
      user.get_events.each do |item|
      #Telegram.send_message(item['description'])
      driver = Selenium::WebDriver.for:phantomjs
      driver.manage.window.maximize

      order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
      total_order = Hash.new
      total_order = Order.prepare(item)

      total_order.each_pair do |shop_name, order_for_shop|
        executed_order = Hash.new
        executed_order = Order.execute(driver, order_for_shop, shop_name.to_s)
        unless executed_order[:error]
          GoogleServices::Table.save_order(ws, order_date, executed_order[:order_list], executed_order[:price_counter])
          puts "В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн."
          #Telegram.send_message("В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
        else
          puts "Не вдалося виконате замовлення, відредагуйте його текст"
          #Telegram.send_message("Не вдалося виконате замовлення, відредагуйте його текст")
        end
      end
      driver.quit
      end
      end
  end
end
