require_relative "test_helper"
require 'capybara/rails'

include OmniAuthStubHelper
prepare_omniauth_for_testing
set_mock_auth_hash

class ActionDispatch::IntegrationTest
  include OmniAuthStubHelper
  include Capybara::DSL

  teardown do
    Capybara.use_default_driver
  end
end
