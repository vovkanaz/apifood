class Order

  def self.prepare(item, user)
    total_order = Hash.new
    order_array = item['description'].split(', ')
      order_array.each do |order_position|
        single_order = Hash.new
        single_order = Order.handle_order_position(order_position)
        if single_order[:shop_name]
          shop_name = single_order[:shop_name].to_sym
          total_order[shop_name] = [] unless total_order[shop_name]
          total_order[shop_name] << single_order
        else
          User.find(user.id).send_message("Неможливо обробити запит \"#{order_position}\". Відредагуйте текст замовлення!")
        end
      end
    total_order
  end

  def self.execute(driver, user, order_for_shop, shop_name)
    module_name = shop_name.gsub(' ', '').constantize
    price_counter = 0
    order_list = Array.new
    order_for_shop.each do |position|
      module_response = module_name.add_order(driver, position)
      if module_response[:error] == false
        price_counter += module_response[:price] * position[:dishes_number]
        order_list << "#{module_response[:dish_name]} --> #{position[:dishes_number]}"
      else
        User.find(user.id).send_message("Неможливо обробити запит \"#{order[:dish_name]}\". Відредагуйте текст замовлення!")
      end
    end
    if order_list
      module_name.send_checkout_form(driver, user.first_name, user.last_name, user.company, user.adress, 
                                     user.room, user.name, user.phone_number)
      return { order_list: order_list, price_counter: price_counter, error: false }
    else
      return { order_list: nil, price_counter: 0, error: true }
    end
  end

  private

  def self.handle_order_position(order_position)
    page_link = nil
    order = Hash.new
    order = params_for_order(order_position)
    dish_name = Editor.delete_needless_symbols(order[:dish_name])
    shops = Shop.all
    shops.each do |shop|
      page_link = get_link(shop[:site_map], dish_name)
      if page_link
        return {shop_name: shop[:name], dish_name: dish_name, dishes_number: order[:dishes_number], link: page_link}
      end
    end
    return {shop_name: nil, dish_name: nil, dishes_number: 0, link: nil} unless page_link
  end

  def self.get_link(site_map, dish_name)
    page_link = nil
    site_map.each_pair do |dishes_array, link|
      dishes_array.each do |dish|
        if Editor.delete_needless_symbols(dish) == dish_name
          page_link = link
          break
        end
      end
      break if page_link
    end
    page_link
  end

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