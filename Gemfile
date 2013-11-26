source 'https://rubygems.org'

# Rails gems
gem 'rails', '4.0.1'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'rails-observers'
gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'cancan'
gem 'haml-rails'
gem 'paperclip'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'gravatar_image_tag'
gem 'squeel'
gem 'kaminari-bootstrap'
gem 'mail_view'
gem 'coveralls', require: false

group :postgresql do
  gem 'pg'
end

group :mysql do
  gem 'mysql2'
end

group :sqlite do
  gem 'sqlite3'
end

group :development do
  gem 'debugger'
  gem 'letter_opener'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rb-fsevent'
  gem 'listen', '0.4.7'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'pry'
end

group :production do
  gem 'unicorn'
  gem 'foreman'
  gem 'foreman-export-initscript'
end
