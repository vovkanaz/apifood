require 'rails_helper'
require 'editor'

describe Editor do

  it "must delete needless symbols and upcase string" do
    str = "\\Бульйон\' кур<я>чий   з \/ \"локшиною"
    result = Editor.delete_needless_symbols(str)
    expect(result).to eq("БУЛЬЙОН КУРЯЧИЙ З ЛОКШИНОЮ")
  end

end