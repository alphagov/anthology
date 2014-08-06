module ApplicationHelper

  def current_user
    if session[:user_id].present?
      @current_user ||= User.where(id: session[:user_id]).first
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate!
    unless user_signed_in?
      redirect_to new_session_path
      false
    end
  end

  def library_title
    ENV['LIBRARY_TITLE'] || "Library"
  end

  def use_developer_strategy?
    Rails.env.development? && ENV["GOOGLE_CLIENT_ID"].blank?
  end

end
