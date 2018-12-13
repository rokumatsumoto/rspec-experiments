require 'sinatra/base'
require 'json'
require_relative 'ledger'
require 'byebug'
require 'ox'

module ExpenseTracker

  class API < Sinatra::Base

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    def stringify_keys(hash)
      hash.collect{|k,v| [k.to_s, v]}.to_h
    end

    post '/expenses', :provides => 'application/json' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    post '/expenses', :provides => 'text/xml' do
      expense = Ox.load(request.body.read, mode: :hash_no_attrs)
      expense = expense.key?(:expense) ? stringify_keys(expense[:expense])
                                       : stringify_keys(expense)
      result = @ledger.record(expense)

      if result.success?
        Ox.dump('expense_id' => result.expense_id)
      else
        status 422
        Ox.dump('error' => result.error_message)
      end
    end

    get '/expenses/:date', :provides => 'application/json' do

      result = @ledger.expenses_on(params['date'])
      if result.empty?
        JSON.generate([])
      else
        JSON.generate(result)
      end
    end

    get '/expenses/:date', :provides => 'text/xml' do
      result = @ledger.expenses_on(params['date'])

      if result.empty?
        Ox.dump([])
      else
        Ox.dump(result)
      end
    end


  end
end
