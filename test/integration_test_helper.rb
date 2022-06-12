require_relative "test_helper"
require "capybara/rails"

include OmniAuthStubHelper # rubocop:disable Style/MixinUsage
prepare_omniauth_for_testing

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    Capybara.use_default_driver

    # The omniauth auth hash gets overwritten in some tests, so we reset it to "the standard one"
    # at the end of each test
    prepare_omniauth_for_testing
  end
end
