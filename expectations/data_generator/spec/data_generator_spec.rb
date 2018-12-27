require 'data_generator'
require 'byebug'

RSpec.describe DataGenerator do

  def be_a_boolean
    # Ruby has no Boolean class so this doesn't work.
    # Is there a way we can use `or` to combine two matchers instead?
    eq(true) | eq(false)
  end

  it "generates boolean values" do
    value = DataGenerator.new.boolean_value
    expect(value).to be_a_boolean
  end

  def be_a_date_before_2000
    # Combine the `be_a(klass)` matcher with the `be < value` matcher
    # to create a matcher that matches dates before January 1st, 2000.
    be_a_kind_of(Date) && be < Date.new(2000,1,1)
  end

  it "generates dates before January 1st, 2000" do
    value = DataGenerator.new.date_value
    expect(value).to be_a_date_before_2000
  end

  def be_an_email_address
    # Pass a simple regex to `match` to define a matcher for email addresses.
    # Don't worry about complete email validation; something very simple is fine.
    match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  it "generates email addresses" do
    value = DataGenerator.new.email_address_value
    expect(value).to be_an_email_address
  end

  def match_the_shape_of_a_user_record
    # Use `be_a_boolean`, `be_a_date_before_2000` and `be_an_email_address`
    # in the hash passed to `match` below to define this matcher.
    be_a_kind_of(Hash) && match(email_address: be_an_email_address,
      date_of_birth: be_a_date_before_2000,
      active: be_a_boolean)
  end

  it "generates user records" do
    user = DataGenerator.new.user_record
    expect(user).to match_the_shape_of_a_user_record
  end

  def all_match_the_shape_of_a_user_record
    # Combine the `all` matcher and `match_the_shape_of_a_user_record` here.
    be_a_kind_of(Array) && (all match_the_shape_of_a_user_record)
  end

  it "generates a list of user records" do
    users = DataGenerator.new.users(4)
    expect(users).to all_match_the_shape_of_a_user_record
  end
end
