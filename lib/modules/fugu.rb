module Fugu

  def self.add_order(driver, position)
    module_respond = Hash.new
    if position[:link]
      driver.get position[:link]
      scroll_page(driver)
      blocks = driver.find_elements(:class, "post")
      blocks.each do |block|
        name = block.find_element(:class, "entry-title").text rescue false
        if Editor.delete_needless_symbols(name.to_s) == position[:dish_name]
          price = block.find_element(:class, "price").text.to_f
          add_to_cart_link = block.find_element(:tag_name, "a").attribute("href")
          driver.get add_to_cart_link
          position[:dishes_number].times do
          	driver.find_element(:class, "single_add_to_cart_button").submit
            sleep 5
          end
          return { price: price, 
                   dish_name: position[:dish_name],
                   error: false }
        end
      end
    else
      module_response = { price: 0, dish_name: nil, error: true }
    end
  end
    
  def self.send_checkout_form(driver, first_name, last_name, company, adress, room, email, phone_number)
    driver.get "http://fugu.ck.ua/cart/"
    sleep 7
    driver.find_element(:id,"billing_first_name").send_keys "#{first_name} #{last_name}"
    driver.find_element(:id,"billing_email").send_keys "#{email}"
    driver.find_element(:id,"billing_phone").send_keys "#{phone_number}"
    driver.find_element(:id,"billing_new_fild8").send_keys "#{adress}"
    driver.find_element(:id,"billing_new_fild5").send_keys "#{room}"
    driver.save_screenshot("./order_screen/Fugu#{DateTime.now}.png")
    #driver.find_element(:id,"place_order").submit
  end

  def self.scroll_page(driver)
    elements = driver.find_elements(:class, 'entry-title')
    elements.each do |element|
      element.location_once_scrolled_into_view
      sleep 1
    end
  end

end