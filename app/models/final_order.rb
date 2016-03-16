class FinalOrder

require "google_drive"
require 'selenium-webdriver'
require_dependency 'telegram_message'
require_dependency 'online_cafe'
require_dependency 'bambolina'
require_dependency 'editor'
require_dependency 'google_auth'
require_dependency 'order'
require_dependency 'site_map_builder'

  def self.handle_order
    #Telegram.send_message("Ваше замовлення обробляеться!")
    User.where.not(oauth_token: nil).each do |user|
      #p user.get_events
      DeferredJob.perform_later
    #puts "UTAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    end
  end


  def self.update_site_map
    driver = Selenium::WebDriver.for:phantomjs
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