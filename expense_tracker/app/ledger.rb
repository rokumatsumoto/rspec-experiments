require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      if !expense.key?('payee') || !expense.key?('amount') || !expense.key?('date')
        message = [
          "Invalid expense:",
          ("`payee` is required" unless expense.key?('payee')),
          ("`amount` is required" unless expense.key?('amount')),
          ("`date` is required" unless expense.key?('date')),
          ].compact.join(" ")
          return RecordResult.new(false, nil, message)
        end

        DB[:expenses].insert(expense)
        id = DB[:expenses].max(:id)
        RecordResult.new(true, id, nil)
      end

      def expenses_on(date)
        DB[:expenses].where(date: date).all
      end
    end
  end

