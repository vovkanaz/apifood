# == Schema Information
# Schema version: 20160406122709
#
# Table name: shops
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  site_map   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
