module Order

  def self.execute(item, driver, module_name)
    module_name = module_name.constantize
    price_counter = 0
    order_list = Array.new
    total_order = item['description'].split(', ')
    total_order.each do |order_position|
      order = Hash.new
      order = params_for_order(order_position)
      puts order[:dish_name]
      puts order[:dishes_number]
      module_response = module_name.add_order(driver, order[:dish_name], order[:dishes_number])
      puts module_response
      unless module_response[:error]
        price_counter += module_response[:price] * order[:dishes_number]
        order_list << "#{module_response[:dish_name]} --> #{order[:dishes_number]}"
      else
        puts "Неможливо обробити запит \"#{order[:dish_name]}\". Відредагуйте текст замовлення!"
        #Telegram.send_message("Неможливо обробити запит \"#{order[:dish_name]}\". Відредагуйте текст замовлення!")
      end
    end
    module_name.send_checkout_form(driver, "First name", "Last name", "Company", "Customer adress", "Room 123", "customer_email@example.com", "0931234567")
    return { order_list: order_list, price_counter: price_counter }
  end

  private

  def self.params_for_order(order_position)
      order_hash = Hash.new
      dishes_number = order_position.split.last
      if dishes_number.to_i != 0
        dish_name = (order_position.split - dishes_number.split).join(' ')
        order_hash = { dish_name: dish_name.squish, dishes_number: dishes_number.to_i }
      else
        order_hash = { dish_name: order_position.squish, dishes_number: 1 }
      end
  end

end