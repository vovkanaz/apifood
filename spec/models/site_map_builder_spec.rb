require 'rails_helper'
require 'site_map_builder'

describe SiteMapBuild do

  methods_for_sites = ["for_online_cafe", "for_bambolina", "for_fugu"]
  methods_for_sites.each do |method_name|

    before(:all) do
	  @driver = Selenium::WebDriver.for :phantomjs
      @driver.manage.window.maximize 
    end
	
    it "builds site map for site" do
	  result = SiteMapBuild.send(method_name, @driver)
      p result
	  if expect(result.respond_to?(:keys)).to be true
        result.each_pair do |key, value|
          expect(key).to_not match_array([])
          expect(value).to be_an_instance_of(String).and include('http')
        end
	  end
    end

    after(:all) do
      @driver.quit
    end

  end

end