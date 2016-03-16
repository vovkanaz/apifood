module Fugu

  def self.scroll_page(driver)
    elements = driver.find_elements(:class, 'entry-title')
    elements.each do |element|
      element.location_once_scrolled_into_view
      sleep 1
    end
  end

end