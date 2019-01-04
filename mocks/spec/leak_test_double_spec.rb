require 'byebug'
class Account
  class << self
    attr_accessor :logger
  end

  def initialize
    @balance = 0
  end

  attr_reader :balance

  def credit(amount)
    @balance += amount
    self.class.logger.log("Credited $#{amount}")
  end
end

RSpec.describe Account do
  it "logs each credit" do
    Account.logger = logger = double("Logger")
    expect(logger).to receive(:log).with("Credited $15")
    account = Account.new
    account.credit(15)
  end

  it "keeps track of the balance" do
    account = Account.new
    expect { account.credit(10) }.to change { account.balance }.by(10)
  end
end
