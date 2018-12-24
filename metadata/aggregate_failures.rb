RSpec.describe 'Billing', aggregate_failures: false do
  context 'using the fake payment service' do
    before do
      expect(MyApp.config.payment_gateway).to include('sandbox')
    end
  end
end
