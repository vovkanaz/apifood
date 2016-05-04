module Bambolina
  
  def self.add_order(driver, position)
    module_respond = Hash.new
    if position[:link]
      driver.get position[:link]
      elements = driver.find_elements(:class, "catItemView")
      elements.each do |element|
    	  name = element.find_element(:class, "catItemTitle").text
        if Editor.delete_needless_symbols(name.to_s) == position[:dish_name]
          input_field = element.find_element(:tag_name, "input")
          input_field.clear
          input_field.send_keys position[:dishes_number]
          element.find_element(:class, "k2store_cart_button").submit
          sleep 10
          product_price = element.find_element(:class, "product_price").text.to_f
          if driver.find_element(:class, "componentheading").text == "Пицца"
            package_array = Array.new
            package_price = 0
            package_array = elements.last.find_element(:class, "catItemTitle").text.split(' ')
            package_array.each {|word| package_price = word.to_f if word.to_f > 0}
            product_price += package_price
          end
          module_respond = { price: product_price, dish_name: position[:dish_name], error: false }
          return module_respond
        end
      end
    else
      module_respond = { price: 0, dish_name: nil, error: true }
    end
  end

  def self.send_checkout_form(driver, first_name, last_name, company, adress, room, email, phone_number)
    driver.get "http://bambolina.ck.ua/mycart"
    sleep 5
    element = driver.find_element(:id, "cart_actions")
    element.find_element(:tag_name, "a").click
    sleep 5
    element = driver.find_element(:class, "remember-email")
    element.find_element(:tag_name, "input").send_keys "#{email}"
    driver.find_element(:class, "k2store_checkout_button").submit
    driver.find_element(:id,"billing_firstname").send_keys "#{first_name} #{last_name}"
    driver.find_element(:id,"billing_address_1").send_keys "#{adress} #{room}"
    driver.find_element(:id,"billing_phone_1").send_keys "#{phone_number}"
    #driver.find_element(:class, "k2store_checkout_button").click
    driver.save_screenshot("./order_screen/Bambolina#{DateTime.now}.png")
  end

end