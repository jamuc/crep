require 'bundler/setup'
require 'crep'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
