require 'rails_helper'
require 'order'

describe Order do
	
	before(:all) do
	  @driver = Selenium::WebDriver.for :phantomjs
      @driver.manage.window.maximize
      @order_position = "Суп з лососем 2"
      @site_map = Shop.first.site_map
      @user = User.first
	end

	it 'executes prepared order and back filled report' do
	  order_for_shop = [{dish_name: "БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ", 
                         dishes_number: 1, 
                         link: "http://online-cafe.ck.ua/site/product-category/pershi-stravi/"}]
	  shop_name = 'Online Cafe'
      result = Order.execute(@driver, @user, order_for_shop, shop_name)
      if expect(result.respond_to?(:keys)).to be true
        result.each_value do |value|
          expect(value).to_not be_nil
        end
      end
	end

	it 'prepares order data before execute it and back not empty hash' do
	  order_array = @order_position.split(', ')
	  result = Order.prepare(order_array, @user)
	  if expect(result.respond_to?(:keys)).to be true
        expect(result.keys).to_not match_array([])
      end
	end

	it 'prepares order data before execute it and back empty hash' do
	  order_array = "Суп".split
	  result = Order.prepare(order_array, @user)
	  if expect(result.respond_to?(:keys)).to be true
        expect(result.keys).to match_array([])
      end
	end

	it 'handles order position and back hash with data' do
	  result = Order.handle_order_position(@order_position)
	  if expect(result.respond_to?(:keys)).to be true
        result.each_value do |value|
          expect(value).to_not be_nil
          expect(value).to_not eq(0)
        end
      end
	end

	it 'handles order position and back hash without data' do
	  order_position = "Суп 2"
	  result = Order.handle_order_position(order_position)
	  if expect(result.respond_to?(:keys)).to be true
        result.each_value do |value|
          expect(value).to be_nil.or eq(0)
        end
      end
	end

	it 'returns link to site page' do
	  dish_name = "СУП З ФРИКАДЕЛЬКАМИ"
	  result = Order.get_link(@site_map, dish_name)
	  expect(result).to be_an_instance_of(String).and include('http')
	end

	it 'returns nil instead link to site page' do
	  dish_name = "СУП"
	  result = Order.get_link(@site_map, dish_name)
	  expect(result).to be_nil
	end

	it 'converts order\'s string into hash back more than 1 dish' do 
      result = Order.params_for_order(@order_position)
      expect(result.respond_to?(:keys)).to be_truthy
      expect(result[:dishes_number]).to be > 1
	end

	it 'converts order\'s string into hash back 1 dish' do 
      order_position = "Сашими с угря"
      result = Order.params_for_order(order_position)
      expect(result.respond_to?(:keys)).to be_truthy
      expect(result[:dishes_number]).to eq(1)
	end

    after(:all) do
      @driver.quit
    end

end