#!/usr/bin/env rake
require File.expand_path("config/application", __dir__)

Books::Application.load_tasks

desc "RuboCop"
task lint: :environment do
  sh "bundle exec rubocop"
end

task default: %i[test lint]
