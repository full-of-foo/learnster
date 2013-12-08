require 'cucumber/rails'
require "logger"
require "parallel_tests"
require "watir-webdriver"
require_relative "../step_definitions/lib/pages/page"
require_relative "./test_config"

include Test::Unit::Assertions
include TestConfig

ENV["RAILS_ENV"] ||= 'production'


# Logging config
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
Log.debug "Rails ENV: #{ENV['RAILS_ENV']}"


# DB and JS config
# ActionController::Base.allow_rescue = false
# begin
#   DatabaseCleaner.strategy = :truncation
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end
# Cucumber::Rails::Database.javascript_strategy = :truncation


# Watir config
if ENV["HEADLESS"] == "1" then
  browser = Watir::Browser.new :phantomjs
  ENV['KILL_ON_EXIT'] = "0"
else
  browser = Watir::Browser.new :firefox
end
INDEX_OFFSET = -1
WEBDRIVER = true
 

# Browser setup and teardown hooks
# system 'bundle exec sunspot-solr stop'
# system 'RAILS_ENV="test" rake db:test:prepare'
# system 'rm log/test.log'
# system "rake stop"
# system 'bundle exec sunspot-solr start -p 8983'
# system 'RAILS_ENV="test" rails s -p 4000 -e test -d'

Before do
  # Log.debug "Cleaning DB....."
  # DatabaseCleaner.clean
  @browser = browser
end

at_exit do 
  # system "rake stop"
  # system 'bundle exec sunspot-solr stop'
  if ENV["KILL_ON_EXIT"] == "1" and (!ENV['HEADLESS'] or ENV['HEADLESS'] == "0")
    Log.debug "Killing all processes named: firefox-bin"
    browser.close
    system "killall 'firefox-bin'"
  end
end
