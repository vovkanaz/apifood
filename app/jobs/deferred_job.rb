class DeferredJob < ActiveJob::Base
  queue_as :default
  require 'google/api_client'
  require 'google_drive'
  require 'selenium-webdriver'
  require_dependency 'online_cafe'
  require_dependency 'bambolina'
  require_dependency 'editor'
  require_dependency 'google_auth'
  require_dependency 'tele_notify'
  
  def perform
    users_orders = Hash.new
    User.where.not(oauth_token: nil).each do |user|
      users_orders[user] = user.get_events
    end
    users_orders.each_pair do |user, events|
      events.each do |item|
        if item['summary'] == 'Order'
          User.find(user.id).send_message("Ваше замовлення обробляється")
          order_array = item['description'].split(', ')
          Manager.handle_order(order_array, user)
        end
      end
    end
  end
end