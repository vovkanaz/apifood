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

class User < ActiveRecord::Base
require 'rest-client'
include Models

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

end
