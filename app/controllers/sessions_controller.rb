class SessionsController < ApplicationController
  skip_before_filter :authenticate!
  skip_before_filter :verify_authenticity_token, only: :create

  def new
    # new.html.erb
  end

  def create
    if auth_hash.nil?
      flash[:alert] = "There was an error whilst trying to sign you in."
      redirect_to new_session_path and return
    end

    @user = User.find_or_create_from_auth_hash(auth_hash)
    warden.set_user(@user)
    redirect_to '/'
  end

  def sign_out
    warden.logout
    redirect_to new_session_path
  end

  def failure
    flash[:alert] = "Please sign in to access the library."
    redirect_to new_session_path
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
