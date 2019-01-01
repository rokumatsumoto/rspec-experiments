# frozen_string_literal: true

RSpec::Matchers.define :have_json do |filter|
  match do |data|
    parsed = JSON.parse(data)
    expect(parsed).to filter
  end
end
