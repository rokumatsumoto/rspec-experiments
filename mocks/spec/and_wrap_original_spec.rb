require 'byebug'

class API
  def self.solve_for(x)
    (1..x).to_a
  end
end


RSpec.describe "and_wrap_original" do
  it "responds as it normally would, modified by the block" do
    expect(API).to receive(:solve_for).and_wrap_original { |m, *args| m.call(*args).first(5) }
    expect(API.solve_for(100)).to eq [1,2,3,4,5]
  end
end
