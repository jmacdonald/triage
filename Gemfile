source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Database Adapters
######################################

# PostgreSQL
gem 'pg'

# MySQL
# gem 'mysql2'

# SQLite
# gem 'sqlite3'

#######################################

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'devise'
gem 'haml-rails'
gem 'paperclip'
gem 'cancan'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'rails_admin'
gem 'gravatar_image_tag'
gem 'squeel'
gem 'kaminari-bootstrap'
gem 'devise_ldap_authenticatable'
gem 'strong_parameters'
gem 'mail_view'

group :development do
  gem 'debugger'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'letter_opener'
end

group :test do
  gem 'minitest'
  gem 'sqlite3'
  gem 'mysql2'
  gem 'rb-fsevent'
  gem 'listen', '0.4.7'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'spork-rails'
  gem 'terminal-notifier-guard'
  gem 'shoulda-matchers'
end

group :production do
  gem 'unicorn'
end
