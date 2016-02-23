require 'active_support/core_ext/string/multibyte'

module Editor

  def self.delete_needless_symbols(str)
    str.gsub!(/'|«|»|\"|\/|<|>|\\/, '')
    str = str.mb_chars.upcase.to_s
    str = str.squish
  end

end