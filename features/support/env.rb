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


# Watir config
if ENV["HEADLESS"] == "1" then
  browser = Watir::Browser.new :phantomjs
  ENV['KILL_ON_EXIT'] = "0"
else
  browser = Watir::Browser.new :firefox
end

INDEX_OFFSET = -1
WEBDRIVER = true
 
Before do
  @browser = browser
end

at_exit do 
  if ENV["KILL_ON_EXIT"] == "1" and (!ENV['HEADLESS'] or ENV['HEADLESS'] == "0")
    Log.debug "Killing all processes named: firefox-bin"
    browser.close
    system "killall 'firefox-bin'"
  end
end
