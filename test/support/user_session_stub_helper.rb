module UserSessionStubHelper
  include Warden::Test::Helpers

  def stub_user_session
    request.env['warden'] = stub(authenticate!: true,
                                 authenticated?: true,
                                 user: stub_user)
  end

  def sign_in_as_stub_user
    login_as stub_user
  end

  def stub_user
    @user ||= create(:user)
  end
end
