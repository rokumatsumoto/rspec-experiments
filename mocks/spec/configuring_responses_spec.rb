require 'timeout'
require 'byebug'

RSpec.describe 'WeatherAPI' do
  it 'is configuring responses' do
    weather_api = double('WeatherAPI')

    counter = 0
    allow(weather_api).to receive(:temperature) do |zip_code|
      counter = (counter + 1) % 4
      counter.zero? ? raise(Timeout::Error) : 35.0
    end

    expect(weather_api.temperature(:eskisehir)).to eq(35.0)
    expect(weather_api.temperature).to eq(35.0)
    expect(weather_api.temperature).to eq(35.0)
    expect { weather_api.temperature }.to raise_error(Timeout::Error)
    expect(weather_api.temperature).to eq(35.0)
    expect(weather_api.temperature).to eq(35.0)
    expect(weather_api.temperature).to eq(35.0)
    expect { weather_api.temperature }.to raise_error(Timeout::Error)
  end
end
