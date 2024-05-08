source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.3.0"

gem "font-awesome-rails"

gem "active_model_serializers"
gem "active_storage_validations"
gem "config"
gem "devise"
gem "faker"
gem "figaro"
gem "i18n-js", "~>3.9.2"
gem "image_processing"
gem "jwt"
gem "pagy"
gem "rails", "~> 7.1.3"
gem "rails-controller-testing"
gem "rails-i18n"
gem "ransack", github: "activerecord-hackery/ransack", branch: "main"
gem "sidekiq"
gem "simplecov"
gem "simplecov-rcov"

gem "sprockets-rails"

gem "mysql2", "~> 0.5"

gem "puma", "< 7"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem "bcrypt"
gem "jbuilder"

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

gem "bootsnap", require: false

gem "bootstrap-sass", "~> 3.4.1"

gem "sassc-rails"

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
