# typed: false
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "mocha/setup"
require "webmock"

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean

WebMock.disable_net_connect!

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

class ActionController::TestCase
  include OmniAuthStubHelper
  include UserSessionStubHelper
end
