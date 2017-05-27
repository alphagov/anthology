require 'test_helper'

describe SessionsController do

  describe 'POST create' do
    let(:auth_hash) {
      { 'uid' => '12345' }
    }
    let(:user) { create(:user) }

    setup do
      stub_omniauth_request_auth_hash(auth_hash)
    end

    it 'signs in a user with the provided auth hash' do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .returns(user)

      post :create, params: { provider: :google }

      assert_equal user.id, @controller.session[:user_id]
      assert_redirected_to root_path
    end

    it 'redirects with error when creating a user fails' do
      User.expects(:find_or_create_from_auth_hash!)
          .with(auth_hash)
          .raises(User::CreationFailure.new('something bad'))

      post :create, params: { provider: :google }

      assert_redirected_to new_session_path
      assert_match /Could not sign you in/, @controller.flash[:alert]
      assert_match /something bad$/, @controller.flash[:alert]
    end
  end

end
