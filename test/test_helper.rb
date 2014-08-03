ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"
require 'webmock'

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
WebMock.disable_net_connect!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include FactoryGirl::Syntax::Methods

  include MetadataLookupStubHelper
  include VersioningHelper

  setup do
    DatabaseCleaner.start

    # TODO: Refactor the metadata lookup behaviour so that we don't have to
    # stub it out before every test.
    stub_metadata_lookup
  end

  teardown do
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include UserSessionStubHelper
end
