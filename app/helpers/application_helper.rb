# frozen_string_literal: true

module ApplicationHelper
  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id].present?
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate!
    redirect_to new_session_path unless user_signed_in?
  end

  def library_title
    ENV['LIBRARY_TITLE'] || 'Library'
  end

  def use_developer_strategy?
    Rails.env.development? && ENV['GOOGLE_CLIENT_ID'].blank?
  end
end
