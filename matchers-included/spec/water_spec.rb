# frozen_string_literal: true

class Water
  def self.elements
    %i[oxygen hydrogen]
  end
end

RSpec.describe Water do
  it 'is H2O' do
    expect(described_class.elements).to contain_exactly(:hydrogen, :oxygen)
  end
end
