module ApplicationHelper

  def warden
    request.env['warden']
  end

  def authenticate!
    warden.authenticate!
  end

  def current_user
    warden.user
  end

  def library_title
    ENV['LIBRARY_TITLE'] || "Library"
  end

  def organization_name
    OpenSesame::Github.organization_name
  end

  def use_developer_strategy?
    (Rails.env.development? || Rails.env.test?) && ENV["GITHUB_CLIENT_ID"].blank?
  end

end
