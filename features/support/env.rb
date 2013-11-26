require 'cucumber/rails'
require 'rspec/rails'
require "logger"
require "parallel_tests"
require "watir-webdriver"
require "factory_girl_rails"
require_relative "../step_definitions/lib/pages/page"

include Sorcery::TestHelpers::Rails


ActionController::Base.allow_rescue = false
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end
Cucumber::Rails::Database.javascript_strategy = :truncation


# Watir config

if ENV["HEADLESS"] then
  require "celerity"
  browser = Celerity::Browser.new
  INDEX_OFFSET = 0
  WEBDRIVER = false
else
  require 'watir-webdriver'
  browser = Watir::Browser.new :firefox
  INDEX_OFFSET = -1
  WEBDRIVER = true
end
 

# Browser setup and teardown hooks

Before do
  @browser = browser
end
 
at_exit do
  browser.close if ENV["KILL_ON_EXIT"] == "1"
end


# Logging

include Test::Unit::Assertions

module Log
    class << self
      attr_accessor :instance
      def debug(log)
        instance.debug(log)
      end
    end
end

if ENV['LOG_VERBOSE'] == '1'
        Log.instance = Logger.new(STDOUT)
else
        Log.instance = Logger.new('/tmp/auto_qa.log', 100, 1024000)
end