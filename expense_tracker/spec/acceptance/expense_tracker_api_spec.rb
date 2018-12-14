require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  include Ox
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)

      post '/expenses', JSON.generate(expense)

      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    def create_xml(expense)
        Ox.default_options=({:with_xml => false})
        doc = Document.new(:version => '1.0')
        expense.each do |key, value|
            e = Element.new(key)
            e << Raw.new(value)
            doc << e
        end
        Ox.dump(doc)
    end

    def post_expense_xml(expense)

      post '/expenses', expense

      expect(last_response.status).to eq(200)
      parsed = Ox.parse_obj(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      # expense.merge('id' => parsed['expense_id'])

    end

    # bundle exec rspec './spec/acceptance/expense_tracker_api_spec.rb[1:1]'
    it 'records submitted expenses using json' do

      header 'Accept', 'application/json'
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10')

      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10')

      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11')

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end

    # bundle exec rspec './spec/acceptance/expense_tracker_api_spec.rb[1:2]'
    it 'records submitted expenses using xml' do

      header 'Accept', 'text/xml'
      coffee = {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'}

      coffee = post_expense_xml(create_xml(coffee))


    end

  end
end
