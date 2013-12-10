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
  download_directory = "#{Dir.pwd}/features/downloads"
  downloads_before = Dir.entries download_directory
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.folderList'] = 2
  profile['browser.download.dir'] = download_directory
  profile['browser.helperApps.neverAsk.saveToDisk'] = "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
  profile['browser.helperApps.neverAsk.openFile'] = "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
  profile['browser.helperApps.alwaysAsk.force'] = 'false'
  
  browser = Watir::Browser.new :firefox, profile: profile
end

# Run hooks 
Before do
  @browser = browser
end

After do
  Log.debug browser.url
  browser.cookies.clear
  browser.refresh
end

at_exit do 
  Dir.glob("#{Dir.pwd}/features/downloads/*").each { |f| File.delete(f) }

  if ENV["KILL_ON_EXIT"] == "1" and (!ENV['HEADLESS'] or ENV['HEADLESS'] == "0")
    Log.debug "Killing all processes named: firefox-bin"
    browser.close
    system "killall 'firefox-bin'"

  end
end
