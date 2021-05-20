class SessionsController < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :verify_authenticity_token, only: :create

  def new; end

  def create
    if auth_hash.blank?
      fail_and_redirect
      return
    end

    @user = User.find_or_create_from_auth_hash!(auth_hash)
    if @user.present?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      fail_and_redirect
    end
  rescue User::CreationFailure => e
    fail_and_redirect("Could not sign you in for the first time: #{e.message}")
  end

  def sign_out
    session[:user_id] = nil
    redirect_to new_session_path
  end

private

  def fail_and_redirect(message = "There was a problem signing you in.")
    flash[:alert] = message
    redirect_to new_session_path
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
