require_relative 'test_helper'

require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers

  setup do
    DatabaseCleaner.clean
  end

  teardown do
    DatabaseCleaner.clean
    Capybara.use_default_driver
    Warden.test_reset!
  end

  def stub_user
    @stub_user ||= FactoryGirl.create(:user)
  end

  def sign_in_as_stub_user
    login_as stub_user
  end

end
