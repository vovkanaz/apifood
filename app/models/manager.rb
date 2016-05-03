class Manager
 
  require "google_drive"
  require 'selenium-webdriver'
  require_dependency 'site_map_builder'
  require_dependency 'online_cafe'
  require_dependency 'bambolina'
  require_dependency 'fugu'
  require_dependency 'editor'
  require_dependency 'google_auth'


  def self.handle_order(order_array, user)
    driver = Selenium::WebDriver.for:phantomjs
    driver.manage.window.maximize

    order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
    total_order = Hash.new
    total_order = Order.prepare(order_array, user)
    worksheet = GoogleServices::Table.define_spreadsheet(user)

    total_order.each_pair do |shop_name, order_for_shop|
      executed_order = Hash.new
      executed_order = Order.execute(driver, user, order_for_shop, shop_name.to_s)
      unless executed_order[:error]
        GoogleServices::Table.save_order(worksheet, order_date, executed_order[:order_list], executed_order[:price_counter])
        User.find(user.id).send_message("В #{shop_name.to_s} Ви замовили \"#{executed_order[:order_list].join(', ')}\" на суму #{executed_order[:price_counter]} грн.")
      else
        User.find(user.id).send_message("Не вдалося виконате замовлення, відредагуйте його текст")
      end
    end
    driver.quit
  end

  def self.update_site_map
    driver = Selenium::WebDriver.for:phantomjs
    driver.manage.window.maximize
    shops = Shop.all
    shops.each do |shop|
      site_map = {}
      if shop.name
        method_name = "for_#{shop.name}".downcase.gsub(' ', '_')
        site_map = SiteMapBuild.send(method_name, driver)
        shop.update_attributes(site_map: site_map) if site_map
      end
    end
    driver.quit
  end
end