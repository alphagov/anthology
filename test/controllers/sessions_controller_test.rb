require "integration_test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  let(:user) { create(:user) }

  describe "POST create" do
    it "redirects with an error if the auth hash is empty" do
      auth_hash = {}
      mock_hash_returned_by_omniauth(auth_hash)

      sign_in_user

      assert_redirected_to new_session_path
      assert_equal "There was a problem signing you in.", @controller.flash[:alert]
    end

    it "signs in a user with the provided auth hash" do
      auth_hash = {
        provider: "google",
        uid: "12345",
        info: {
          name: user.name,
          email: user.email,
        },
      }
      mock_hash_returned_by_omniauth(auth_hash)

      sign_in_user

      assert_equal user.id, @controller.session[:user_id]
      assert_redirected_to root_path
    end

    it "redirects with an error if the user cannot be found" do
      auth_hash = { "uid" => "12345" }
      mock_hash_returned_by_omniauth(auth_hash)

      User.expects(:find_or_create_from_auth_hash!)
        .with(auth_hash)
        .returns(nil)

      sign_in_user

      assert_nil @controller.session[:user_id]
      assert_redirected_to new_session_path
    end

    it "redirects with error when creating a user fails" do
      auth_hash = { "uid" => "12345" }
      mock_hash_returned_by_omniauth(auth_hash)

      User.expects(:find_or_create_from_auth_hash!)
        .with(auth_hash)
        .raises(User::CreationFailure.new("something bad"))

      sign_in_user

      assert_redirected_to new_session_path
      assert_match(/Could not sign you in/, @controller.flash[:alert])
      assert_match(/something bad$/, @controller.flash[:alert])
    end
  end

  describe "GET sign_out" do
    it "clears the session and redirects" do
      auth_hash = {
        provider: "google",
        uid: "12345",
        info: {
          name: user.name,
          email: user.email,
        },
      }
      mock_hash_returned_by_omniauth(auth_hash)

      sign_in_user

      assert_equal user.id, @controller.session[:user_id]

      get sign_out_path
      assert_nil @controller.session[:user_id]
      assert_redirected_to new_session_path
    end
  end
end
