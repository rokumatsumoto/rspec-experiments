# frozen_string_literal: true

require 'byebug'
PublicCompany = Struct.new(:name, :value_per_share, :share_count) do
  def got_better_than_expected_revenues
    self.value_per_share *= rand(1.05..1.10)
  end

  def market_cap
    value_per_share * share_count
  end
end

RSpec.describe PublicCompany do
  let(:company) { described_class.new('Nile', 10, 100_000) }

  it 'increases its market cap when it gets better than expected revenues' do
    expect do
      company.got_better_than_expected_revenues
    end.to change(company, :market_cap).by_at_least(50_000)
  end

  it 'provides attributes' do
    expect(company).to have_attributes(
      name: 'Nile',
      value_per_share: 10,
      share_count: 100_000,
      market_cap: 1_000_000
    )
  end
end
