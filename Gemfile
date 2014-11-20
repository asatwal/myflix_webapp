source 'https://rubygems.org'
ruby '2.1.4'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt'                       # Authenticating users and hold encrypted passwords
gem 'bootstrap_form'               # Forms that handle displaying of errors back to user
gem 'figaro'                       # Environment variable management
gem 'sidekiq'                      # Processing of background jobs
gem 'sinatra', require: false
gem 'slim'
gem 'unicorn'                      # Muti-threaded Ruby server
gem 'foreman'                      # To start prcesses based on Procfile on heroku
gem 'paratrooper'                  # Easy deployment to heroku with rake tasks

gem 'carrierwave'                  # Uploading files
gem 'mini_magick'                  # Image processing

# Processing credit card payments without merchant account and gateway
gem 'stripe'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'sentry-raven', git: 'https://github.com/getsentry/raven-ruby.git'
end

