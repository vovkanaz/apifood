require 'rails_helper'
require 'google_auth'

describe GoogleServices do

  before(:all) do
    user = User.new(oauth_token: "ya29.CjLXAiXUGUF7aSzeJOq_E8o_EzwPtYxd0xhuMlam_vDb86TIaVS-b9bY5D7pwkiBWNp-9g")
    @ws = GoogleServices::Table.define_spreadsheet(user)
  end

  it "define worksheet for user\'s GoogleDrive" do
    expect(@ws).to be_an_instance_of(GoogleDrive::Worksheet)
  end

  it "save report to user\'s spreadsheet" do
  	order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
    order_list = ["БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ --> 2"]
    price_counter = 123
    result = GoogleServices::Table.save_order(@ws, order_date, order_list, price_counter)
    expect(result).to be_truthy
  end

end