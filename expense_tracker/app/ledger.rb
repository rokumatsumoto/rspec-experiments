# frozen_string_literal: true

require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      return invalid_response('payee') unless expense.key?('payee')

      return invalid_response('amount') unless expense.key?('amount')

      return invalid_response('date') unless expense.key?('date')

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end

    private

    def invalid_response(str)
      message = "Invalid expense: `#{str}` is required"
      RecordResult.new(false, nil, message)
    end
  end
end
