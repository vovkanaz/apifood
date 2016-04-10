class Manager

  
  require "google_drive"
  require 'selenium-webdriver'
  require_dependency 'site_map_builder'
  require_dependency 'telegram_message'
  require_dependency 'online_cafe'
  require_dependency 'bambolina'
  require_dependency 'fugu'
  require_dependency 'editor'
  require_dependency 'google_auth'
  require_dependency 'tele_notify'


  def self.update_site_map
    driver = Selenium::WebDriver.for:phantomjs
    driver.manage.window.maximize
    shops = Shop.all
    shops.each do |shop|
      site_map = {}
      if shop.name
        method_name = "for_#{shop.name}".downcase.gsub(' ', '_')
        puts method_name
        site_map = SiteMapBuild.send(method_name, driver)
        shop.update_attributes(site_map: site_map) if site_map
      end
    end
    driver.quit
  end
end