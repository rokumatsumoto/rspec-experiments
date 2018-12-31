
require 'date'
Calendar = Struct.new(:date_string) do
  def on_weekend?
    [0, 6, 7].include?(Date.parse(date_string).wday)
  end
end

RSpec.describe Calendar do
  let(:sunday_date) { Calendar.new('Sun, 11 Jun 2017') }

  it 'considers sundays to be on the weekend' do
    expect(sunday_date).to be_on_weekend
  end
end
