$VERBOSE = true
require 'ruby_warning_filter'
$stderr = RubyWarningFilter.new($stderr)

require_relative 'app/api'
run ExpenseTracker::API.new

