require 'site_map.rb'

module OnlineCafe

    def self.add_order(driver, dish_name, dishes_number)
      page_link = nil
      SiteMap.online_cafe.each_pair do |dishes_array, link|
        page_link = link if dishes_array.include?(dish_name)
      end
      unless page_link.nil?
        driver.get page_link
        puts "Page title #{driver.title}"
        elements = driver.find_elements(:tag_name, "li")
        puts elements
        elements.each do |element|
            name = element.find_element(:tag_name, "h3").text rescue false
            if name == dish_name
              dishes_number.times do
                element.find_element(:link, "Добавить в корзину").click
                puts "Page title #{driver.title} click"
                sleep 7
              end
              return element.find_element(:class, "amount").text.to_f
            end
        end
      end
    end
    
    def self.send_checkout_form(driver, first_name, last_name, company, adress, room, email, phone_number)
      driver.get "http://online-cafe.ck.ua/site/checkout/"
      #puts "Page title #{driver.title}"
      driver.find_element(:id,"billing_first_name").send_keys "#{first_name}"
      driver.find_element(:id,"billing_last_name").send_keys "#{last_name}"
      driver.find_element(:id,"billing_company").send_keys "#{company}"
      driver.find_element(:id,"billing_address_1").send_keys "#{adress}"
      driver.find_element(:id,"billing_address_2").send_keys "#{room}"
      driver.find_element(:id,"billing_email").send_keys "#{email}"
      driver.find_element(:id,"billing_phone").send_keys "#{phone_number}"
    end

end