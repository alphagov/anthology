OpenSesame::Github.organization_name = ENV['GITHUB_ORG'] || 'alphagov'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, { :fields => [:name, :id], :uid_field => :id } unless Rails.env.production?
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
end

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.scope_defaults :team_member, :strategies => [:opensesame_github]
  manager.failure_app = SessionsController.action(:failure)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id) rescue false
end
