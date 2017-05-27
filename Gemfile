source 'https://rubygems.org'
ruby "~> 2.4.1"

gem 'rails', '5.0.3'

gem 'pg'
gem 'googlebooks'
gem 'openlibrary'

gem 'omniauth-google-oauth2'

gem "formtastic"
gem "possessive"
gem 'has_scope'

gem 'rack-ssl-enforcer'

gem 'paper_trail', '~> 7.0.2'

gem 'jquery-rails'

gem 'airbrake', '~> 4.0.0'
gem 'puma'

gem 'sass-rails',   '~> 5.0.6'
gem 'uglifier', '~> 3.2.0'

group :test, :development do
  gem 'pry-byebug'
end

group :test do
  gem "minitest-spec-rails"
  gem "capybara"
  gem "factory_girl_rails", '4.1.0'
  gem "database_cleaner"
  gem "webmock", require: false
  gem "mocha", require: false
end

group :production do
  gem 'rails_12factor'
end
