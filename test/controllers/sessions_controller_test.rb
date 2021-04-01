require "test_helper"

describe SessionsController do
  let(:auth_hash) do
    { "uid" => "12345" }
  end
  let(:user) { create(:user) }

  setup do
    stub_omniauth_request_auth_hash(auth_hash)
  end

  describe "POST create" do
    it "redirects with an error when the auth hash is empty" do
      stub_omniauth_request_auth_hash({})
      post :create, params: { provider: :google }

      assert_redirected_to new_session_path
      assert_equal "There was a problem signing you in.", @controller.flash[:alert]
    end

    it "signs in a user with the provided auth hash" do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .returns(user)

      post :create, params: { provider: :google }

      assert_equal user.id, @controller.session[:user_id]
      assert_redirected_to root_path
    end

    it "redirects with an error if the user cannot be found" do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .returns(nil)

      post :create, params: { provider: :google }

      assert_nil @controller.session[:user_id]
      assert_redirected_to new_session_path
    end

    it "redirects with error when creating a user fails" do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .raises(User::CreationFailure.new("something bad"))

      post :create, params: { provider: :google }

      assert_redirected_to new_session_path
      assert_match(/Could not sign you in/, @controller.flash[:alert])
      assert_match(/something bad$/, @controller.flash[:alert])
    end
  end

  describe "GET sign_out" do
    it "clears the session and redirects" do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .returns(user)

      post :create, params: { provider: :google }
      assert_equal user.id, @controller.session[:user_id]

      get :sign_out
      assert_nil @controller.session[:user_id]
      assert_redirected_to new_session_path
    end
  end
end
