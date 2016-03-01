module SiteMap

  def self.build_for_online_cafe(driver)
  	driver.get "http://online-cafe.ck.ua/site/shop/"
    site_map = Hash.new
  	categories = Array.new
    links_to_categories = Array.new
  	categories = driver.find_elements(:class, "product-category")
    puts categories
  	categories.each { |category| links_to_categories << category.find_element(:tag_name, "a").attribute("href") }
    puts links_to_categories
    links_to_categories.each do |link|
      product_array = []
      driver.get link
      elements = driver.find_elements(:tag_name, "li")
      puts elements
      elements.each do |element|
        product_title = element.find_element(:class, "products-list-title").text rescue nil
        product_array << product_title if product_title
      end
      puts product_array
      site_map[product_array] = link
    end
    puts site_map
    site_map
  end

end