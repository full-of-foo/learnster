#!/usr/bin/env ruby
raise "Supply all ENV params: first_name, surname, email and password" if ENV["FIRST_NAME"]
  .nil? || ENV["SURNAME"].nil? || ENV["EMAIL"].nil? || ENV["PASSWORD"].nil?


# load Rails
ENV['RAILS_ENV'] = ARGV[0] || 'production'
DIR = File.dirname(__FILE__)
require DIR + '/../config/environment'

app_admin = AppAdmin.new(email: ENV["EMAIL"],
                         first_name: ENV["FIRST_NAME"],
                         password: ENV["PASSWORD"],
                         password_confirmation: ENV["PASSWORD"],
                         surname: ENV["SURNAME"])
app_admin.save!
