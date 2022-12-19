ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start "rails"

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "mocha/minitest"

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include FactoryBot::Syntax::Methods

  include VersioningHelper

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
