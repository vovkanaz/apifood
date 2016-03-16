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
     session = GoogleDrive.saved_session("config.json")
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
     ws = session.spreadsheet_by_key("1xHpCUwP29EK-Z5fpk9WHLJpxPdvtNJ2HhP-nmk9RxeU").worksheets[0]
     User.where.not(oauth_token: nil).each do |user|

      user.get_events.each do |item|
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
          Telegram.send_message("В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
        else
          Telegram.send_message("Не вдалося виконате замовлення, відредагуйте його текст")
        end
      end
      driver.quit
      end
      end
  end
end
