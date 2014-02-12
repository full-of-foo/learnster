source "https://rubygems.org"
# ruby "2.0.0"

gem "coffee-rails", "4.0.0" #gemfile hack
# gem "rails", "4.0.2"
gem 'rails', git: 'https://github.com/rails/rails', branch: '4-0-stable'

group :development, :test do
  gem "coffee-rails-source-maps"
  gem "teaspoon"
  gem "guard-teaspoon"
  gem 'guard-cucumber'
  gem "ruby_gntp"
  gem "rails-erd"
end

group :test do
  gem "rb-fsevent"
  gem "terminal-notifier-guard"
  gem 'cucumber-rails', :require => false
  gem "watir-webdriver"
  gem "parallel_tests"
end

gem "jbuilder", "1.0.2"
gem "progress_bar"
gem "acts_as_xlsx"
gem "axlsx_rails"
gem "rubyzip",  "~> 0.9.9"
gem "roo"
gem "bcrypt-ruby", "~> 3.1.2"
gem 'will_paginate', '~> 3.0.5'
gem 'api-pagination'
gem "faker"
gem 'enumerize'
gem 'daemons'
gem 'delayed_job_active_record',
  :git => 'https://github.com/panter/delayed_job_active_record.git',
  :branch => 'master'

group :development do
  gem "populator"
end

gem "sass-rails", "4.0.0"
gem "bootstrap-sass-rails", "2.3.2.1"
gem "jquery-rails", "~> 3.0.4"
gem "eco", :require => "eco"
gem "uglifier", "2.1.1"
gem "font-awesome-rails"
gem "rabl"
gem "oj"
gem "gon", '4.1.1'
gem "js-routes"
gem "spinjs-rails"
gem "datejs-rails"
gem "pg", "0.15.1"
gem "carrierwave"
gem "rmagick"

group :doc do
  gem "sdoc", "0.3.20", require: false
end

group :production do
  gem "rails_12factor", "0.0.2"
  gem 'capistrano', "2.15.5"
  gem "unicorn", "~> 4.7.0"
end
