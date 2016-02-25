
module Telegram
 require 'net/http'
  def self.send_message(order)
    token = '159528223:AAFA-XoRiLy3-fYxKWDdwZy6hacbsKKJox4'
    chatID  = 60930144
    params = {chat_id: chatID, text: order }
    uri = URI("https://api.telegram.org/bot#{token}/sendMessage")
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end
end
