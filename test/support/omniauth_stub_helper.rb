module OmniAuthStubHelper
  # suitable for integration tests
  def prepare_omniauth_for_testing
    OmniAuth.config.test_mode = true
    mock_hash_returned_by_omniauth
  end

  def mock_hash_returned_by_omniauth(hash_returned = mock_auth_hash)
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(hash_returned)
  end

  def sign_in_user_with_capybara
    visit new_session_path
    click_on "Sign in with Google"
  end

  def sign_in_user
    post "/auth/google"
    follow_redirect!
  end

  def signed_in_user
    User.find_by(email: mock_auth_hash[:info][:email])
  end

  def mock_auth_hash
    {
      provider: "google",
      uid: "12345",
      info: {
        name: "Stub User",
        email: "stub.user@example.org",
      },
    }
  end
end
