module ExpenseTrackerMatchers
  def an_expense_identified_by(id)
    a_hash_including(id: id).and including(:payee, :amount, :date)
  end
end
