# typed: strict
require_relative "test_helper"
require "capybara/rails"

include OmniAuthStubHelper # rubocop:disable Style/MixinUsage
prepare_omniauth_for_testing

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    Capybara.use_default_driver
  end
end
