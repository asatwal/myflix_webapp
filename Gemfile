source 'https://rubygems.org'
ruby '2.1.4'

gem 'bcrypt'                       # Authenticating users and hold encrypted passwords
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'draper'                       # Helper for decorators
gem 'haml-rails'
gem 'jquery-rails'
gem 'rails', '4.1.1'
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap_form'               # Forms that handle displaying of errors back to user
gem 'figaro'                       # Environment variable management
gem 'sidekiq'                      # Processing of background jobs
gem 'sinatra', require: false
gem 'slim'
gem 'stripe_event'                 # Stripe webhook integration for Rails 
gem 'unicorn'                      # Muti-threaded Ruby server
gem 'foreman'                      # To start prcesses based on Procfile on heroku
gem 'paratrooper'                  # Easy deployment to heroku with rake tasks

gem 'carrierwave'                  # Uploading files
gem 'mini_magick'                  # Image processing

# Processing credit card payments without merchant account and gateway
gem 'stripe'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
  gem 'pry'
  gem 'pry-nav'
  gem 'sqlite3'
  gem 'thin'
end

group :development, :test do
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-webkit'    # Replacement for Selenium so you don't have to run with Firefox
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver' # For feature tests with Capybara
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'vcr'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'sentry-raven', git: 'https://github.com/getsentry/raven-ruby.git'
end

