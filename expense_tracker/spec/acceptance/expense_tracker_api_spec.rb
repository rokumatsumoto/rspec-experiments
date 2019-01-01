# frozen_string_literal: true

require 'rack/test'
require 'json'
require_relative '../../app/api'
# require_relative '../../spec/support/api_helpers'
require_relative '../../spec/support/shared_context/api_shared_context'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include_context 'API helpers'

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)

      expect(last_response.status).to eq(200)
      expect(json_last_response).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => json_last_response['expense_id'])
    end

    def post_expense_xml(expense)
      post '/expenses', helpers.create_xml(expense)

      expect(last_response.status).to eq(200)
      expect(xml_last_response).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => xml_last_response['expense_id'])
    end

    it 'records submitted expenses using json' do
      header_json
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end

    it 'records submitted expenses using xml' do
      header_xml
      coffee = {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
      zoo = {
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      }
      groceries = {
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      }

      coffee = post_expense_xml(coffee)
      zoo = post_expense_xml(zoo)
      post_expense_xml(groceries)

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = Ox.load(last_response.body, mode: :hash_no_attrs, symbolize_keys: false)

      expenses = expenses['expense_tracker'].each do |_key, value|
        value.each do |ke, _val|
          ke.each do |k, v|
            ke[k] = v.to_f if k == 'amount'
            ke[k] = v.to_i if k == 'id'
          end
        end
      end

      expect(expenses['expense']).to contain_exactly(coffee, zoo)
    end
  end
end
