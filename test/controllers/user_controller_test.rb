require "test_helper"

describe UserController do
  it "gets the user page" do
    stub_user_session
    user = User.all.first

    get :show, params: { id: user.id }

    assert_response :success
    assert_template "show"
  end
end
