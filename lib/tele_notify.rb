require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))

module TeleNotify

  if defined?(ActiveRecord::Base)
    require 'tele_notify/telegram_user'
    require 'tele_notify/telegram_controller'
  end

end
