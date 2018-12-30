require 'byebug'

MissingDataError = Class.new(StandardError)

RSpec.describe 'Block Matchers' do

  example 'raise error block' do
    expect { 'hello'.world }.to raise_error(NoMethodError) do |ex|
      expect(ex.name).to eq(:world)
    end
  end

  example 'expect to raise name error, but will pass' do
    expect { age__of(user) }.not_to raise_error(MissingDataError)
  end

  example 'throw' do
    expect { throw :found }.to throw_symbol(:found)
  end

  example 'throw with a return value' do
    expect { throw :found, 10 }.to throw_symbol(:found, a_value > 9)
  end
end


class Host
  extend RSpec::Matchers

  def self.just_yield
    yield
  end

  def self.just_yield_these(*args)
    yield(*args)
  end

  expect { |block_checker| just_yield(&block_checker) }.to yield_control

  expect { |block| 2.times(&block) }.to yield_control.twice

  expect { |block|
   just_yield_these(10, 'food', Math::PI, &block)
   }.to yield_with_args(10, /foo/, a_value_within(0.1).of(3.14))

   expect { |block| just_yield_these(&block) }.to yield_with_no_args

   expect { system('echo OK') }.to output("OK\n").to_stdout_from_any_process
 end

