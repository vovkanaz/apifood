require 'rails_helper'
require 'online_cafe'
require 'bambolina'
require 'fugu'
require 'selenium-webdriver'

describe "Shops" do

  shops = ["OnlineCafe", "Bambolina", "Fugu"]
  shops.each_with_index do |shop, index|

    before(:all) do
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.manage.window.maximize
    end
   
    it "makes order on site" do
      order_positions = [{shop_name: "Online Cafe", 
                          dish_name: "БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ", 
                          dishes_number: 1, 
                          link: "http://online-cafe.ck.ua/site/product-category/pershi-stravi/"},
                         {shop_name: "Bambolina", 
                          dish_name: "ДЕСЕРТ АНЖЕЛИКА", 
                          dishes_number: 1, 
                          link: "http://bambolina.ck.ua/menu-pizzerii/deserty"},
                         {shop_name: "Fugu", 
                          dish_name: "САШИМИ С УГРЯ", 
                          dishes_number: 1, 
                          link: "http://fugu.ck.ua/product-category/sushi-i-sashimi/"}]
      result = shop.constantize.add_order(@driver, order_positions[index])
      expect(result.keys).to_not match_array([])
      expect(result[:error]).to be_falsy
    end

    it "send checkout form for site" do
      result = shop.constantize.send_checkout_form(@driver, "first_name", "last_name", "company", 
      	                            "adress", "room", "my-email@gmail.com", "phone_number")
      expect(result).to be_truthy.and be_an_instance_of(File)
    end

    after(:all) do
      @driver.quit
    end
  end

end