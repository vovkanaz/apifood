
require 'rails_helper'
describe "Authentication:" do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      :uid => '100697159705286292170',
      :info => {
        :email => "vovkanz@gmail.com",
        :name => 'Володимир Назарко'
      }
    })

 end

  describe "Test user login" do
    it "expect work" do
      get '/auth/google_oauth2/', nil, {"omniauth.auth" => OmniAuth.config.mock_auth[:google_oauth2]}
       #expect(response.body).to include("Выберите аккаунт")
  	   expect(response).to redirect_to("/auth/google_oauth2/callback")
  	   end
   end

 describe User do
 
   before(:context) do	
   user = User.last
   @get = user.get_events

   end

   it "can get events" do
   	  @get.each do |i|
   	  	expect(i['description']).to include("БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ")
   	 end 	
   end

  end
  end
