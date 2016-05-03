require 'rails_helper'
require 'google_auth'

describe GoogleServices do

  before(:all) do
    @user = User.new(oauth_token: "ya29.CjLXAn_6QL76uqv9sgQPAkhjJge0ORm2LRY975TANB8k875c7oW6J1ckSokCPfOQPOiYyQ")
    @ws = GoogleServices::Table.define_spreadsheet(@user)
    @order_date = DateTime.now.strftime('%m.%d.%Y в %I:%M%p')
    @order_list = ["БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ --> 2"]
    @price_counter = 123
  end

  it "define worksheet for user\'s GoogleDrive" do
    expect(@ws).to be_an_instance_of(GoogleDrive::Worksheet)
  end

  it "save report to user\'s spreadsheet" do
    result = GoogleServices::Table.save_order(@ws, @order_date, @order_list, @price_counter)
    expect(result).to be_truthy
  end

end