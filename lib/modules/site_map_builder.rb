module SiteMapBuild

  def self.for_online_cafe(driver)
    online_cafe_hash = { link: "http://online-cafe.ck.ua/site/shop/",
                         categories: [:class, "product-category"],
                         products: [:tag_name, "li"],
                         product_title: [:class, "products-list-title"]}
    get_site_map(driver, online_cafe_hash)
  end

  def self.for_bambolina(driver)
    bambolina_hash = { link: "http://bambolina.ck.ua/menu-pizzerii",
                       categories: [:class, "subCategory"],
                       products: [:class, "catItemView"],
                       product_title: [:class, "catItemTitle"]}
    get_site_map(driver, bambolina_hash)
  end

  private

  def self.get_site_map(driver, params_hash)
    driver.get params_hash[:link]
    site_map = Hash.new
    categories = Array.new
    links_to_categories = Array.new
    categories = driver.find_elements(params_hash[:categories].first, params_hash[:categories].last)
    categories.each { |category| links_to_categories << category.find_element(:tag_name, "a").attribute("href") }
    links_to_categories.each do |link|
      product_titles_array = []
      driver.get link
      sleep 10
      products = driver.find_elements(params_hash[:products].first, params_hash[:products].last)
      products.each do |product|
        product_title = product.find_element(params_hash[:product_title].first, params_hash[:product_title].last).text
        product_titles_array << product_title if product_title
      end
      site_map[product_titles_array] = link
    end
    site_map
  end

end