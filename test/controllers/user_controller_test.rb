require "integration_test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  before do
    post "/auth/google"
    follow_redirect!
  end

  it "gets the user page" do
    my_user = User.find_by(email: "stub.user@example.org")

    get user_url(my_user.id)

    assert_response :success
    assert_match(/Stub User’s Books/, @response.body)
  end
end
