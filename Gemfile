ruby '2.1.1'
source 'https://rubygems.org'

gem 'rails', '4.1.1'
gem 'pg'
gem 'jbuilder', '~> 2.0'
gem 'decent_exposure'
gem 'decent_decoration'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'rack-cors', require: 'rack/cors'
gem 'geocoder'
gem 'virtus'
gem 'figaro'
gem 'seedbank'
gem 'capistrano', '~> 3.2.0'
gem 'gcm'
gem 'pg_search'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'hashie'
gem 'kaminari'
gem 'haml'

group :test, :development do
  gem 'factory_girl_rails', require: false
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'konacha'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'faker'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'codeclimate-test-reporter'
  gem 'database_cleaner'
end

group :development do
  gem 'better_errors'
  gem 'checker', require: false, github: 'netguru/checker'
  gem 'spring'
end
