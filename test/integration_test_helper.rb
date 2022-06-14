require_relative "test_helper"
require "capybara/rails"

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include OmniAuthStubHelper

  before do
    prepare_omniauth_for_testing
  end

  after do
    Capybara.use_default_driver
  end
end
