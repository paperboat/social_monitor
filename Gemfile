source 'https://rubygems.org'

gem 'rails', '3.2.11'

  gem 'sqlite3'

# Database
group :development do
  # The thin webserver
  gem 'thin'
  # Use Capistrano for the deployment
    gem 'capistrano'
    gem 'rvm-capistrano'
end
group :production do
  gem 'mysql2'
  gem 'unicorn'
end

# Automatic PayPal
gem 'activemerchant'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# devise for authentication
gem 'devise'

# Twitter Bootstrap for layout
gem "therubyracer"
gem "less-rails"
gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'

# Crawler
gem 'anemone'