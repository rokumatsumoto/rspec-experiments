RSpec::Matchers.define :have_json_expect do |expected|
  match do |actual|
    parsed = JSON.parse(actual)
    expect(parsed).to expected
  end
end
