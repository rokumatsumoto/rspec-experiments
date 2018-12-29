require 'uri'
RSpec::Matchers.define_negated_matcher :be_non_empty, :be_empty
RSpec.describe 'Higher Order Matchers' do
  def evens_up_to(n = 0)
    0.upto(n).select(&:odd?)
  end

  example 'define negated matcher' do
    expect(evens_up_to).to be_non_empty.and all be_even
  end

  example 'have attributes matcher' do
    uri = URI('http://github.com/rspec/rspec')
    expect(uri).to have_attributes(host: 'github.com', path: '/rspec/rspec')
  end

  example 'an object having attributes matcher' do
    uri = URI('http://github.com/rspec/rspec')
    expect([uri]).to include(an_object_having_attributes(host: 'github.com'))
  end
end


