require 'sinatra/base'
require 'json'
require_relative 'ledger'
require 'byebug'
require 'ox'

module ExpenseTracker
  class API < Sinatra::Base
    include Ox

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    PATHS = %w[POST/expenses GET/expenses/].freeze

    not_found do
      halt 404 , 'Not Found' unless PATHS.any? { |path| (request.request_method + request.path_info).end_with?(path) }
      halt 406, 'Not Acceptable' if request.preferred_type(%w[application/json text/xml]) == nil
      halt 415, 'Unsupported media type' if PATHS.any? { |path| (request.request_method + request.path_info).end_with?(path) }
    end

    helpers do
      def create_xml(expense_list, element_name = 'expense',
       root_name = 'expense_tracker')

        # We need array for root element
        expense_list = [expense_list]  unless expense_list.is_a?(Array)

        Ox.default_options=({:with_xml => false})
        doc = Document.new(:version => '1.0')
        root = Element.new(root_name)
        expense_list.each do |e|
          element = Element.new(element_name)
          e.each do |key, value|
            b = Element.new(key)
            b << value.to_s
            element << b
          end
          root << element
        end
        doc << root
        Ox.dump(doc)
      end

      def header_content_type(accept)
        halt 415, 'Unsupported media type' unless request.content_type == accept
      end
    end

    post '/expenses', :provides => 'application/json' do

      header_content_type 'application/json'
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

      header_content_type 'text/xml'
      expense = Ox.load(request.body.read, {mode: :hash_no_attrs, symbolize_keys: false})
      expense = expense.key?('expense_tracker') ? expense.dig("expense_tracker", "expense")
      : expense.dig("expense")
      expense = expense.each {|k, v| expense[k] = v.to_f if k == 'amount'  }

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
        create_xml(result)
      end
    end
  end
end
