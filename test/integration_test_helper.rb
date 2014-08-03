require_relative "test_helper"
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include UserSessionStubHelper

  teardown do
    Capybara.use_default_driver
    Warden.test_reset!
  end
end
