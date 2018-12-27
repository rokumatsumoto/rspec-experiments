
RSpec.configure do |config|
    config.add_setting :fail_if_slower_than
    config.around(:example, :fail_if_slower_than) do |example|
      time = example.metadata[:fail_if_slower_than]
      started_at = Time.now
      example.run
      raise "example takes too long. #{Time.now - started_at}" if Time.now - started_at > time
    end
end
