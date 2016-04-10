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
  require_dependency 'tele_notify'
  
  def perform
    User.where.not(oauth_token: nil).each do |user|
      worksheet = GoogleServices::Table.define_spreadsheet(user)
      user.get_events.each do |item|
        if item['summary'] == 'Order'
          #User.find(user.id).send_message("Ваш запит обробляеться")
          driver = Selenium::WebDriver.for:phantomjs
          driver.manage.window.maximize

          order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
          total_order = Hash.new
          total_order = Order.prepare(item, user)

          total_order.each_pair do |shop_name, order_for_shop|
            executed_order = Hash.new
            executed_order = Order.execute(driver, user, order_for_shop, shop_name.to_s)
            unless executed_order[:error]
              GoogleServices::Table.save_order(worksheet, order_date, executed_order[:order_list], executed_order[:price_counter])
              #User.find(user.id).send_message("В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
            else
              #User.find(user.id).send_message("Не вдалося виконате замовлення, відредагуйте його текст")
            end
          end
          driver.quit
        end
      end
    end
  end
end
