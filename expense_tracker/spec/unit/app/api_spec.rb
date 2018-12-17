require_relative '../../../app/api'
require 'rack/test'
require_relative '../../../spec/support/api_helpers'


module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods
    include ApiHelpers

    def app
      API.new(ledger: ledger)
    end

    def helpers
      app.helpers
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do

      context 'when the expense is successfully recorded using json' do

        let(:expense) { { 'some' => 'data' } }


        before do
          header_json
          allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.body).to have_json_expect(include('expense_id' => 417))
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation using json' do

        let(:expense) { { 'some' => 'data' } }

        before do
          header_json
          allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.body).to have_json_expect(include('error' => 'Expense incomplete'))
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(422)
        end
      end

      context 'when the expense content type is not supported' do

        before do
          header 'Content-Type', 'text/plain'
          header 'Accept', 'application/json'
        end

        it 'responds with a 415 (Unsupported media type)' do
          text = 'some = data'

          post '/expenses', text

          expect(last_response.status).to eq(415)
        end

        it 'returns an unsupported media type message' do
          text = 'some = data'

          post '/expenses', text

          expect(last_response.body).to eq("Unsupported media type")
        end
      end

      context 'when the expense accept header is not supported' do

        let(:expense) { { 'some' => 'data' } }

        before do
          header 'Accept', 'text/plain'
          header 'Content-Type', 'application/json'
        end

        it 'responds with a 406 (Not Acceptable)' do

          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(406)
        end

        it 'returns an unsupported media type message' do
          text = 'some = data'

          post '/expenses', text

          expect(last_response.body).to eq("Not Acceptable")
        end
      end

      context 'when the expense url path is wrong ' do

        let(:expense) { { 'some' => 'data' } }

        before do
          header_json
        end

        it 'responds with a 404 (Not Found)' do

          post '/expensesdsf3', JSON.generate(expense)

          expect(last_response.status).to eq(404)
        end

        it 'returns a not found message' do

          post '/expensesdsf3', JSON.generate(expense)

          expect(last_response.body).to eq("Not Found")
        end
      end

    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date return json' do

        before do
          header_json
          allow(ledger).to receive(:expenses_on)
          .with('2017-06-10')
          .and_return(['expense_1', 'expense_2'])
        end

        it 'returns the expense records in JSON' do
          get "/expenses/2017-06-10"

          expect(last_response.body).to eq(JSON.generate(['expense_1', 'expense_2']))
        end
        it 'responds with a 200 (OK)' do
          get "/expenses/2017-06-10"

          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date return json' do

        before do
          header_json
          allow(ledger).to receive(:expenses_on)
          .with('2017-06-10')
          .and_return([])
        end

        it 'retuns an empty array in JSON' do
          get "/expenses/2017-06-10"
          expect(last_response.body).to eq(JSON.generate([]))
        end

        it 'responds with a 200 (OK)' do
          get "/expenses/2017-06-10"
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
