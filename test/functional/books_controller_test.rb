require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  setup do
    login_as_stub_user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
