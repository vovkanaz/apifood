module OnlineCafe

    def self.add_order(driver, position)
      module_respond = Hash.new
      if position[:link]
        driver.get position[:link]
        elements = driver.find_elements(:tag_name, "li")
        puts elements
        elements.each do |element|
          name = element.find_element(:tag_name, "h3").text rescue false
          if Editor.delete_needless_symbols(name.to_s) == position[:dish_name]
            position[:dishes_number].times do
              element.find_element(:link, "Добавить в корзину").click
              sleep 7
            end
            module_response = { price: element.find_element(:class, "amount").text.to_f, 
                               dish_name: position[:dish_name],
                               error: false }
            return module_response
          end
        end
      else
        module_response = { price: 0, dish_name: nil, error: true }
      end
    end
    
    def self.send_checkout_form(driver, first_name, last_name, company, adress, room, email, phone_number)
      driver.get "http://online-cafe.ck.ua/site/checkout/"
      driver.find_element(:id,"billing_first_name").send_keys "#{first_name}"
      driver.find_element(:id,"billing_last_name").send_keys "#{last_name}"
      driver.find_element(:id,"billing_company").send_keys "#{company}"
      driver.find_element(:id,"billing_address_1").send_keys "#{adress}"
      driver.find_element(:id,"billing_address_2").send_keys "#{room}"
      driver.find_element(:id,"billing_email").send_keys "#{email}"
      driver.find_element(:id,"billing_phone").send_keys "#{phone_number}"
      driver.save_screenshot("./order_screen/OnlineCafe#{DateTime.now}.png")
    end

end