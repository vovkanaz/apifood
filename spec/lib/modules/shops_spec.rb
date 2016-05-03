require 'rails_helper'
require 'online_cafe'
require 'bambolina'
require 'fugu'
require 'selenium-webdriver'

describe "Shops" do

  @shops = ["OnlineCafe", "Bambolina", "Fugu"]
  @shops.each_with_index do |shop, index|

    before(:all) do
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.manage.window.maximize
      @order_positions = [{shop_name: "Online Cafe", 
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
    end
   
    it "makes order on site" do
      response = shop.constantize.add_order(@driver, @order_positions[index])
      expect(response.keys).to_not match_array([])
      expect(response[:error]).to be_falsy
    end

    it "send checkout form for site" do
      response = shop.constantize.send_checkout_form(@driver, "first_name", "last_name", "company", 
      	                            "adress", "room", "my-email@gmail.com", "phone_number")
      expect(response).to be_truthy.and be_an_instance_of(File)
    end

    after(:all) do
      @driver.quit
    end
  end

end