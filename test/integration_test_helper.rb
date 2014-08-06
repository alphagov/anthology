require_relative "test_helper"
require 'capybara/rails'

include OmniAuthStubHelper
prepare_omniauth_for_testing

class ActionDispatch::IntegrationTest
  include OmniAuthStubHelper
  include Capybara::DSL

  teardown do
    Capybara.use_default_driver
  end
end
