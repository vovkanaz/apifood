# == Schema Information
# Schema version: 20160406122709
#
# Table name: users
#
#  id               :integer          not null, primary key
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  oauth_token      :string(255)
#  tele_chat_id     :string(255)
#  oauth_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  first_name       :string(255)
#  last_name        :string(255)
#  company          :string(255)
#  adress           :string(255)
#  room             :string(255)
#  phone_number     :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
