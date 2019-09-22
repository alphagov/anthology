# frozen_string_literal: true

require_relative 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include OmniAuthStubHelper
  include Capybara::DSL

  prepare_omniauth_for_testing

  teardown do
    Capybara.use_default_driver
  end
end
